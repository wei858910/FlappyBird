class APipeActor : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent Root;

    UPROPERTY()
    TArray<USceneComponent> PipeGroup;

    protected TArray<bool> PipeGroupUsed;

    protected float ScorePosition = -130;

    UPaperSprite UpPipeSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Pipes/pipe_down_Sprite.pipe_down_Sprite"));
    UPaperSprite DownPipSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Pipes/pipe_up_Sprite.pipe_up_Sprite"));

    protected float UpPipeSpritePositionZ = 230;
    protected float DownPipSpritePositionZ = -230;

    protected float MinOffsetZ = -80;
    protected float MaxOffsetZ = 150;
    protected float DistanceX = 220.0;
    protected float PositionX = 180.0;
    protected float PipeOutOfRange = -200.0;

    protected const int32 GroupSize = 3;

    protected float PipeMoveSpeed = 0.0;

    UFUNCTION(BlueprintOverride)
    void ConstructionScript()
    {
        for (int32 i = 0; i < GroupSize; i++)
        {
            USceneComponent GroupRoot = Cast<USceneComponent>(CreateComponent(USceneComponent::StaticClass(), FName(f"GroupRootComp{i}")));
            GroupRoot.AttachToComponent(RootComponent);

            UPaperSpriteComponent UpPipeSpriteComp = Cast<UPaperSpriteComponent>(CreateComponent(UPaperSpriteComponent::StaticClass(), FName(f"UpPipeSprite{i}")));
            UPaperSpriteComponent DownPipSpriteComp = Cast<UPaperSpriteComponent>(CreateComponent(UPaperSpriteComponent::StaticClass(), FName(f"DownPipeSprite{i}")));
            UpPipeSpriteComp.SetSprite(UpPipeSprite);
            DownPipSpriteComp.SetSprite(DownPipSprite);
            UpPipeSpriteComp.AttachToComponent(GroupRoot, GroupRoot.Name);
            DownPipSpriteComp.AttachToComponent(GroupRoot, GroupRoot.Name);

            UpPipeSpriteComp.SetRelativeLocation(FVector(0, 0, UpPipeSpritePositionZ));
            DownPipSpriteComp.SetRelativeLocation(FVector(0, 0, DownPipSpritePositionZ));

            PipeGroup.Add(GroupRoot);
            PipeGroupUsed.Add(false);
        }
    }

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        ResetPipeGroupPosition();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        UpdatePipeMove(DeltaSeconds);
    }

    void ResetPipeGroupPosition()
    {
        for (int32 i = 0; i < GroupSize; i++)
        {
            PipeGroup[i].SetRelativeLocation(FVector(PositionX + i * DistanceX, 0.0, RandPipeGroupOffsetZ()));
        }
    }

    void SetPipeMoveSpeed(float Speed = 100.0)
    {
        PipeMoveSpeed = Speed;
    }

    protected float RandPipeGroupOffsetZ()
    {
        return Math::RandRange(MinOffsetZ, MaxOffsetZ);
    }

    protected void UpdatePipeMove(float DeltaSeconds)
    {
        for (int32 i = 0; i < GroupSize; i++)
        {
            PipeGroup[i].AddRelativeLocation(FVector::ForwardVector * PipeMoveSpeed * -1 * DeltaSeconds);
            if (PipeGroup[i].GetRelativeLocation().X < PipeOutOfRange)
            {
                int32 FollowSite = i == 0 ? GroupSize - 1 : i - 1;
                float LastPipePositionX = PipeGroup[FollowSite].GetRelativeLocation().X;
                PipeGroup[i].SetRelativeLocation(FVector(LastPipePositionX, 0.0, RandPipeGroupOffsetZ()) + FVector::ForwardVector * DistanceX);
                PipeGroupUsed[i] = false;
            }

            if (PipeGroup[i].GetRelativeLocation().X < ScorePosition && !PipeGroupUsed[i])
            {
                PipeGroupUsed[i] = true;
                ABirdGameState BirdGameState = Cast<ABirdGameState>(Gameplay::GetGameState());
                if (IsValid(BirdGameState))
                {
                    BirdGameState.AddScore();
                    int32 BirdScore = BirdGameState.GetScore();
                    Log(f"Score = {BirdScore}");
                }
            }
        }
    }
};