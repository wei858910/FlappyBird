class ABirdGameMode : AGameMode
{
	ABgActor   BgActor;
	ALandActor LandActor;

	default DefaultPawnClass = ABirdPawn::StaticClass();

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		BgActor = Cast<ABgActor>(SpawnActor(ABgActor::StaticClass(), FVector(0.0, -10.0, 0.0)));
		LandActor = Cast<ALandActor>(SpawnActor(ALandActor::StaticClass(), FVector(0.0, 0.0, -210)));

		SpawnActor(APipeActor::StaticClass());
	}
};