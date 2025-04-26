class ABgActor : AActor
{
	UPROPERTY(DefaultComponent, RootComponent)
	UPaperSpriteComponent BgRenderComp;

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		RandomBgSprite();
	}

	void RandomBgSprite()
	{
		FString		 DayBgPath = "/Game/Textures/Background/bg_day_Sprite.bg_day_Sprite";
		FString		 NightBgPath = "/Game/Textures/Background/bg_night_Sprite.bg_night_Sprite";
		UPaperSprite BgSprite = Cast<UPaperSprite>(LoadObject(nullptr, Math::RandBool() ? DayBgPath : NightBgPath));
		BgRenderComp.SetSprite(BgSprite);
	}
};