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

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
	}
};