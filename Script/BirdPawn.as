class ABirdPawn : APawn
{
	UPROPERTY(DefaultComponent, RootComponent)
	USceneComponent Root;

	UPROPERTY(DefaultComponent)
	UPaperFlipbookComponent BirdRenderComp;

	UPaperFlipbook BirdFlipbook = Cast<UPaperFlipbook>(LoadObject(nullptr, "/Game/Animations/Birds/PF_RedBrid.PF_RedBrid"));
	default BirdRenderComp.SetFlipbook(BirdFlipbook);

	UPROPERTY()
	float OrthoWidth = 1000.0;

	UPROPERTY(DefaultComponent)
	UCameraComponent Camera;
	default Camera.SetRelativeRotation(FRotator(0.0, -90.0, 0.0));
	default Camera.SetProjectionMode(ECameraProjectionMode::Orthographic);
	default Camera.SetRelativeLocation(FVector(0.0, 60.0, 0.0));
	default Camera.SetOrthoWidth(OrthoWidth);

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
	}
};