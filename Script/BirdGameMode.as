class ABirdGameMode : AGameMode
{
    ABgActor   BgActor;
    ALandActor LandActor;
    APipeActor PipeActor;

    default DefaultPawnClass = ABirdPawn::StaticClass();
    default GameStateClass = ABirdGameState::StaticClass();

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        BgActor = Cast<ABgActor>(SpawnActor(ABgActor::StaticClass(), FVector(0.0, -10.0, 0.0)));
        LandActor = Cast<ALandActor>(SpawnActor(ALandActor::StaticClass(), FVector(0.0, 2.0, -210)));
        PipeActor = Cast<APipeActor>(SpawnActor(APipeActor::StaticClass()));
    }

    UFUNCTION(Exec)
    void ChangeGameState(int32 State)
    {
        if (State == 0) // Start Game
        {
            BeginGame();
        }
        else if (State == 1) // Reset Game
        {
        }
    }

    void BeginGame()
    {
        if (IsValid(PipeActor))
        {
            PipeActor.SetPipeMoveSpeed();
        }

        if (IsValid(LandActor))
        {
            LandActor.SetLandMoveSpeed();
        }

        ABirdPawn BirdPawn = Cast<ABirdPawn>(Gameplay::GetPlayerPawn(0));
        if (IsValid(BirdPawn))
        {
            BirdPawn.ChangeBirdState(EBirdState::EBS_Fly);
        }
    }
};