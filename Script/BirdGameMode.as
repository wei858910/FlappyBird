enum EBirdGameState
{
    EBGS_Menu,
    EBGS_Gaming,
    EBGS_BirdDrop,
    EBGS_ResetGame,
    EBGS_GameOver
}

class ABirdGameMode : AGameMode
{
    ABgActor   BgActor;
    ALandActor LandActor;
    APipeActor PipeActor;
    ABirdPawn  BirdPawn;

    protected EBirdGameState CurrentGameState;

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
            ChangeBirdGameState(EBirdGameState::EBGS_Gaming);
        }
        else if (State == 1) // Reset Game
        {
            ResetGame();
            ChangeBirdGameState(EBirdGameState::EBGS_Menu);
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

        BirdPawn = Cast<ABirdPawn>(Gameplay::GetPlayerPawn(0));
        if (IsValid(BirdPawn))
        {
            BirdPawn.ChangeBirdState(EBirdState::EBS_Fly);
        }
    }

    void ChangeBirdGameState(EBirdGameState State)
    {
        switch (State)
        {
            case EBirdGameState::EBGS_Menu:
                break;
            case EBirdGameState::EBGS_Gaming:
                BeginGame();
                break;
            case EBirdGameState::EBGS_BirdDrop:
                StopSceneObject();
                break;
            case EBirdGameState::EBGS_ResetGame:
                ResetGame();
                break;
            case EBirdGameState::EBGS_GameOver:
                StopSceneObject();
                break;
            default:
                break;
        }
        CurrentGameState = State;
    }

    protected void StopSceneObject()
    {
        if (IsValid(PipeActor))
        {
            PipeActor.SetPipeMoveSpeed(0.0);
        }
        if (IsValid(LandActor))
        {
            LandActor.SetLandMoveSpeed(0.0);
        }
        if (IsValid(BirdPawn))
        {
            BirdPawn.ChangeBirdState(EBirdState::EBS_Drop);
        }
    }

    protected void ResetGame()
    {
        if (IsValid(BgActor))
        {
            BgActor.RandomBgSprite();
        }

        if (IsValid(LandActor))
        {
            LandActor.SetLandMoveSpeed();
        }

        if (IsValid(PipeActor))
        {
            PipeActor.ResetPipeGroupPosition();
        }

        if (IsValid(BirdPawn))
        {
            BirdPawn.ChangeBirdState(EBirdState::EBS_Idle);
        }
    }
};