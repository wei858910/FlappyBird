class APipeActor : AActor
{
	UPROPERTY(DefaultComponent, RootComponent)
	USceneComponent Root;

	UPROPERTY()
	TArray<USceneComponent> PipeGroup;

	UPaperSprite UpPipeSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Pipes/pipe_up_Sprite.pipe_up_Sprite"));
	UPaperSprite DownPipSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Pipes/pipe_down_Sprite.pipe_down_Sprite"));

	UFUNCTION(BlueprintOverride)
	void ConstructionScript()
	{
		for (int32 i = 0; i < 3; i++)
		{
			USceneComponent GroupRoot = Cast<USceneComponent>(CreateComponent(USceneComponent::StaticClass(), FName(f"GroupRootComp{i}")));
			GroupRoot.AttachToComponent(RootComponent);

			UPaperSpriteComponent UpPipeSpriteComp = Cast<UPaperSpriteComponent>(CreateComponent(UPaperSpriteComponent::StaticClass(), FName(f"UpPipeSprite{i}")));
			UPaperSpriteComponent DownPipSpriteComp = Cast<UPaperSpriteComponent>(CreateComponent(UPaperSpriteComponent::StaticClass(), FName(f"DownPipeSprite{i}")));
			UpPipeSpriteComp.SetSprite(UpPipeSprite);
			DownPipSpriteComp.SetSprite(DownPipSprite);
			UpPipeSpriteComp.AttachToComponent(GroupRoot, GroupRoot.Name);
			DownPipSpriteComp.AttachToComponent(GroupRoot, GroupRoot.Name);

			UpPipeSpriteComp.SetRelativeLocation(FVector(0, 0, 230));
			DownPipSpriteComp.SetRelativeLocation(FVector(0, 0, -230));

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
	}

	void ResetPipeGroupPosition()
	{
		for (int32 i = 0; i < 3; i++)
		{
			PipeGroup[i].SetRelativeLocation(FVector(150.0 + i * 150.0, 0.0, 0.0));
		}
	}
};