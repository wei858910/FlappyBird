class ALandActor : AActor
{
	UPROPERTY(DefaultComponent, RootComponent)
	USceneComponent Root;

	UPaperSprite LandSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Land/land_Sprite.land_Sprite"));

	UPROPERTY(DefaultComponent)
	UPaperSpriteComponent Land1RenderComp;
	default Land1RenderComp.SetSprite(LandSprite);

	UPROPERTY(DefaultComponent)
	UPaperSpriteComponent Land2RenderComp;
	default Land2RenderComp.SetSprite(LandSprite);
	default Land2RenderComp.SetRelativeLocation(FVector(336.0, 0.0, 0.0));

	UPROPERTY()
	float LandMoveSpeed = 200.0;

	float MoveSize = 336.0;
	float OutOfRange = -336.0;

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
	}

	UFUNCTION(BlueprintOverride)
	void Tick(float DeltaSeconds)
	{
		UpdateMove(DeltaSeconds);
	}

	void UpdateMove(float DeltaSeconds)
	{
		if (!IsValid(Land1RenderComp) || !IsValid(Land2RenderComp))
		{
			return;
		}
		Land1RenderComp.AddRelativeLocation(FVector::ForwardVector * -1.0 * LandMoveSpeed * DeltaSeconds);
		Land2RenderComp.AddRelativeLocation(FVector::ForwardVector * -1.0 * LandMoveSpeed * DeltaSeconds);

		if (Land1RenderComp.GetRelativeLocation().X < OutOfRange)
		{
			Land1RenderComp.SetRelativeLocation(Land2RenderComp.GetRelativeLocation() + FVector::ForwardVector * MoveSize);
		}

		if (Land2RenderComp.GetRelativeLocation().X < OutOfRange)
		{
			Land2RenderComp.SetRelativeLocation(Land1RenderComp.GetRelativeLocation() + FVector::ForwardVector * MoveSize);
		}
	}
};