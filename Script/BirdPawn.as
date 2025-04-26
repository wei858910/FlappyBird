class ABirdPawn : APawn
{
	UPROPERTY(DefaultComponent, RootComponent)
	USceneComponent Root;

	UPROPERTY(DefaultComponent)
	UPaperFlipbookComponent BirdRenderComp;

	UPaperFlipbook BirdFlipbook = Cast<UPaperFlipbook>(LoadObject(nullptr, "/Game/Animations/Birds/PF_RedBrid.PF_RedBrid"));
	default BirdRenderComp.SetFlipbook(BirdFlipbook);
	default BirdRenderComp.BodyInstance.bLockXRotation = true;
	default BirdRenderComp.BodyInstance.bLockYRotation = true;

	UPROPERTY()
	float OrthoWidth = 520.0;

	UPROPERTY()
	float Impulse = 400.0;

	UPROPERTY(DefaultComponent)
	UCameraComponent Camera;
	default Camera.SetRelativeRotation(FRotator(0.0, -90.0, 0.0));
	default Camera.SetProjectionMode(ECameraProjectionMode::Orthographic);
	default Camera.SetRelativeLocation(FVector(0.0, 60.0, 0.0));
	default Camera.SetOrthoWidth(OrthoWidth);

	UPROPERTY(DefaultComponent)
	UInputComponent InputComp;

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		InputComp.BindAction(n"DoFly", EInputEvent::IE_Pressed, Delegate = FInputActionHandlerDynamicSignature(this, n"OnDoFly"));
	}

	UFUNCTION()
private void OnDoFly(FKey Key)
	{
		Log("OnDoFly called !!!");

		BirdRenderComp.SetSimulatePhysics(true);
		BirdRenderComp.SetPhysicsLinearVelocity(FVector::ZeroVector);
		BirdRenderComp.AddImpulse(FVector::UpVector * Impulse, NAME_None, true);
	}
};