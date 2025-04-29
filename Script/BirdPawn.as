enum EBirdState
{
    EBS_Idle,
    EBS_Fly,
    EBS_Drop,
    EBS_Dead
}

class ABirdPawn : APawn
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent Root;

    UPROPERTY(DefaultComponent)
    UPaperFlipbookComponent BirdRenderComp;

    UPaperFlipbook BirdFlipbook = Cast<UPaperFlipbook>(LoadObject(nullptr, "/Game/Animations/Birds/PF_RedBrid.PF_RedBrid"));
    default BirdRenderComp.SetFlipbook(BirdFlipbook);
    default BirdRenderComp.BodyInstance.bLockXRotation = true;
    // default BirdRenderComp.BodyInstance.bLockYRotation = true;
    default BirdRenderComp.BodyInstance.bLockZRotation = true;
    default BirdRenderComp.BodyInstance.bLockXTranslation = true;
    default BirdRenderComp.BodyInstance.bLockYTranslation = true;
    default BirdRenderComp.SetCollisionProfileName(n"OverlapAll");
    // default BirdRenderComp.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
    default BirdRenderComp.OnComponentBeginOverlap.AddUFunction(this, n"OnBirdRenderComponentBeginOverlap");

    UPROPERTY()
    float OrthoWidth = 500.;

    UPROPERTY()
    float Impulse = 300.;

    UPROPERTY(DefaultComponent)
    UCameraComponent Camera;
    default Camera.SetRelativeRotation(FRotator(0., -90., 0.));
    default Camera.SetProjectionMode(ECameraProjectionMode::Orthographic);
    default Camera.SetRelativeLocation(FVector(0., 60., 0.));
    default Camera.SetOrthoWidth(OrthoWidth);

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    protected EBirdState CurrentBirdState = EBirdState::EBS_Idle;

    protected float UpVelocityFactor = 15.;

    protected float BobbingDirection = 1.;
    protected float BobbingFactor = 25.;
    protected float BobbingRange = 10.;
    protected float CurveTick = 0.;

    protected bool bFadeOnce = false;

    UPROPERTY()
    UCurveFloat BobbingCurve;

    UPROPERTY()
    USoundWave FlySound;

    UPROPERTY()
    USoundWave DeadSound;

    UPROPERTY()
    USoundWave DashSound;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        InputComp.BindAction(n"DoFly", EInputEvent::IE_Pressed, Delegate = FInputActionHandlerDynamicSignature(this, n"OnDoFly"));

        BobbingCurve = Cast<UCurveFloat>(LoadObject(nullptr, "/Game/Data/Curve/CV_BirdBobbing.CV_BirdBobbing"));
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        UpdateBirdHeadOrientation(DeltaSeconds);
        BobbingFlight(DeltaSeconds);
    }

    void ChangeBirdState(EBirdState State)
    {
        if (CurrentBirdState == State)
        {
            return;
        }

        switch (State)
        {
            case EBirdState::EBS_Idle:
                BirdRenderComp.SetRelativeLocation(FVector::ZeroVector);
                BirdRenderComp.SetRelativeRotation(FRotator::ZeroRotator);
                break;
            case EBirdState::EBS_Fly:
                BirdRenderComp.SetSimulatePhysics(true);
                break;
            case EBirdState::EBS_Drop:
            case EBirdState::EBS_Dead:
            {
                if (!bFadeOnce)
                {
                    APlayerController PC = Cast<APlayerController>(GetController());
                    if (IsValid(PC))
                    {
                        ABirdHUD BirdHUD = Cast<ABirdHUD>(PC.GetHUD());
                        if (IsValid(BirdHUD))
                        {
                            BirdHUD.StartScreeFade();
                            bFadeOnce = true;
                        }
                    }
                }
                if (CurrentBirdState == EBirdState::EBS_Dead)
                {
                    if (!IsValid(DeadSound))
                    {
                        DeadSound = Cast<USoundWave>(LoadObject(nullptr, "/Game/Sounds/dead.dead"));
                    }
                    if (IsValid(DeadSound))
                    {
                        Gameplay::PlaySound2D(DeadSound);
                    }
                    bFadeOnce = false;
                    BirdRenderComp.SetSimulatePhysics(false);
                }
                break;
            }
        }
        CurrentBirdState = State;
    }

    UFUNCTION()
    private void OnDoFly(FKey Key)
    {
        if (CurrentBirdState != EBirdState::EBS_Fly)
        {
            return;
        }

        if (!IsValid(FlySound))
        {
            FlySound = Cast<USoundWave>(LoadObject(nullptr, "/Game/Sounds/fly.fly"));
        }
        if (IsValid(FlySound))
        {
            Gameplay::PlaySound2D(FlySound);
        }

        BirdRenderComp.SetPhysicsLinearVelocity(FVector::ZeroVector);
        BirdRenderComp.AddImpulse(FVector::UpVector * Impulse, NAME_None, true);
    }

    UFUNCTION()
    private void OnBirdRenderComponentBeginOverlap(UPrimitiveComponent OverlappedComponent, AActor OtherActor, UPrimitiveComponent OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult&in SweepResult)
    {
        if (CurrentBirdState == EBirdState::EBS_Idle || CurrentBirdState == EBirdState::EBS_Dead)
        {
            return;
        }

        if (IsValid(Cast<APipeActor>(OtherActor)))
        {
            if (!IsValid(DashSound))
            {
                DashSound = Cast<USoundWave>(LoadObject(nullptr, "/Game/Sounds/dash.dash"));
            }
            if (IsValid(DashSound))
            {
                Gameplay::PlaySound2D(DashSound);
            }
            ChangeBirdState(EBirdState::EBS_Drop);
            ABirdGameMode BirdGameMode = Cast<ABirdGameMode>(Gameplay::GetGameMode());
            if (IsValid(BirdGameMode))
            {
                BirdGameMode.ChangeBirdGameState(EBirdGameState::EBGS_BirdDrop);
            }
        }
        else
        {
            ChangeBirdState(EBirdState::EBS_Dead);
            ABirdGameMode BirdGameMode = Cast<ABirdGameMode>(Gameplay::GetGameMode());
            if (IsValid(BirdGameMode))
            {
                BirdGameMode.ChangeBirdGameState(EBirdGameState::EBGS_GameOver);
            }
        }
    }

    protected void UpdateBirdHeadOrientation(float DeltaSeconds)
    {
        if (CurrentBirdState == EBirdState::EBS_Fly || CurrentBirdState == EBirdState::EBS_Drop)
        {
            FVector UpVelocity = BirdRenderComp.GetPhysicsLinearVelocity();
            // Log(f"{UpVelocity}");

            float PitchValue = UpVelocity.Z * UpVelocityFactor * DeltaSeconds;

            BirdRenderComp.SetRelativeRotation(FRotator(PitchValue, 0., 0.));
        }
    }

    protected void BobbingFlight(float DeltaSeconds)
    {
        if (CurrentBirdState == EBirdState::EBS_Idle)
        {
            // BirdRenderComp.AddRelativeLocation(FVector::UpVector * BobbingDirection * BobbingFactor * DeltaSeconds);
            // // if(BirdRenderComp.GetRelativeLocation().Z > BobbingMaxRange || BirdRenderComp.GetRelativeLocation().Z < BobbingMinRange)
            // // {
            // //     BobbingDirection *= -1.0;
            // // }

            // BobbingDirection *= (Math::Abs(BirdRenderComp.GetRelativeLocation().Z) > BobbingRange ? -1 : 1);

            float32 MinTime = 0.;
            float32 MaxTime = 0.;
            if (!IsValid(BobbingCurve))
            {
                BobbingCurve = Cast<UCurveFloat>(LoadObject(nullptr, "/Game/Data/Curve/CV_BirdBobbing.CV_BirdBobbing"));
            }
            if (IsValid(BobbingCurve))
            {
                BobbingCurve.GetTimeRange(MinTime, MaxTime);
                CurveTick += DeltaSeconds;
                if (CurveTick > MaxTime)
                {
                    CurveTick = MinTime;
                }

                float Value = BobbingCurve.GetFloatValue(CurveTick);
                BirdRenderComp.SetRelativeLocation(FVector(0., 0., Value * BobbingFactor));
            }
        }
    }
};