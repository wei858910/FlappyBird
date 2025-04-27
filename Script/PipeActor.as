class APipeActor : AActor
{
	UPROPERTY(DefaultComponent, RootComponent)
	USceneComponent Root;

	UPROPERTY()
	TArray<USceneComponent> PipeGroup;

	UPaperSprite UpPipeSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Pipes/pipe_up_Sprite.pipe_up_Sprite"));
	UPaperSprite DownPipSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Pipes/pipe_down_Sprite.pipe_down_Sprite"));

	float UpPipeSpritePositionZ = 230;
	float DownPipSpritePositionZ = -230;

	float MinOffsetZ = -80;
	float MaxOffsetZ = 150;
	float DistanceX = 150.0;
	float PositionX = 150.0;

	const int32 GroupSize = 3;

	float PipeMoveSpeed = 100.0;

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

protected float RandPipeGroupOffsetZ()
	{
		return Math::RandRange(MinOffsetZ, MaxOffsetZ);
	}

protected void UpdatePipeMove(float DeltaSeconds)
	{
		for (auto Pipe : PipeGroup)
		{
			Pipe.AddRelativeLocation(FVector::ForwardVector * PipeMoveSpeed * -1 * DeltaSeconds);
		}
	}
};