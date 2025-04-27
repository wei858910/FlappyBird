class ABirdGameMode : AGameMode
{
    ABgActor   BgActor;
    ALandActor LandActor;
    APipeActor PipeActor;

    default DefaultPawnClass = ABirdPawn::StaticClass();

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        BgActor = Cast<ABgActor>(SpawnActor(ABgActor::StaticClass(), FVector(0.0, -10.0, 0.0)));
        LandActor = Cast<ALandActor>(SpawnActor(ALandActor::StaticClass(), FVector(0.0, 2.0, -210)));
        PipeActor = Cast<APipeActor>(SpawnActor(APipeActor::StaticClass()));
    }
};