class ABirdGameMode : AGameMode
{
	default DefaultPawnClass = ABirdPawn::StaticClass();

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
	}
};