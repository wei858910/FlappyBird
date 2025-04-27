class ABirdPawn : APawn
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent Root;

    UPROPERTY(DefaultComponent)
    UPaperFlipbookComponent BirdRenderComp;

    UPaperFlipbook BirdFlipbook = Cast<UPaperFlipbook>(LoadObject(nullptr, "/Game/Animations/Birds/PF_RedBrid.PF_RedBrid"));
    default BirdRenderComp.SetFlipbook(BirdFlipbook);
    default BirdRenderComp.BodyInstance.bLockXRotation = true;
    default BirdRenderComp.BodyInstance.bLockYRotation = true;
    default BirdRenderComp.BodyInstance.bLockZRotation = true;
    default BirdRenderComp.BodyInstance.bLockXTranslation = true;
    default BirdRenderComp.BodyInstance.bLockYTranslation = true;
    default BirdRenderComp.SetCollisionProfileName(n"OverlapAll");
    default BirdRenderComp.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
    default BirdRenderComp.OnComponentBeginOverlap.AddUFunction(this, n"OnBirdRenderComponentBeginOverlap");

    UPROPERTY()
    float OrthoWidth = 520.0;

    UPROPERTY()
    float Impulse = 400.0;

    UPROPERTY(DefaultComponent)
    UCameraComponent Camera;
    default Camera.SetRelativeRotation(FRotator(0.0, -90.0, 0.0));
    default Camera.SetProjectionMode(ECameraProjectionMode::Orthographic);
    default Camera.SetRelativeLocation(FVector(0.0, 60.0, 0.0));
    default Camera.SetOrthoWidth(OrthoWidth);

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UFUNCTION()
    private void OnBirdRenderComponentBeginOverlap(UPrimitiveComponent OverlappedComponent, AActor OtherActor, UPrimitiveComponent OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult&in SweepResult)
    {
        Log("OK");
    }

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {

        InputComp.BindAction(n"DoFly", EInputEvent::IE_Pressed, Delegate = FInputActionHandlerDynamicSignature(this, n"OnDoFly"));
    }

    UFUNCTION()
    private void OnDoFly(FKey Key)
    {
        Log("OnDoFly called !!!");

        BirdRenderComp.SetSimulatePhysics(true);
        BirdRenderComp.SetPhysicsLinearVelocity(FVector::ZeroVector);
        BirdRenderComp.AddImpulse(FVector::UpVector * Impulse, NAME_None, true);
    }
};