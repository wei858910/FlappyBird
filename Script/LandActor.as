class ALandActor : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent Root;

    // UPaperSprite LandSprite = Cast<UPaperSprite>(LoadObject(nullptr, "/Game/Textures/Land/land_Sprite.land_Sprite"));

    // UPROPERTY(DefaultComponent)
    // UPaperSpriteComponent Land1RenderComp;
    // default Land1RenderComp.SetSprite(LandSprite);

    // UPROPERTY(DefaultComponent)
    // UPaperSpriteComponent Land2RenderComp;
    // default Land2RenderComp.SetSprite(LandSprite);
    // default Land2RenderComp.SetRelativeLocation(FVector(336.0, 0.0, 0.0));

    UStaticMesh        LandMesh = Cast<UStaticMesh>(LoadObject(nullptr, "/Game/Mesh/Plane.Plane"));
    UMaterialInterface LandMat = Cast<UMaterialInterface>(LoadObject(nullptr, "/Game/Materials/M_LandSprite.M_LandSprite"));

    UPROPERTY(DefaultComponent)
    UStaticMeshComponent LandMeshComp;
    default LandMeshComp.SetRelativeRotation(FRotator(0.0, 0.0, 90.0));
    default LandMeshComp.SetRelativeScale3D(FVector(3.0, 1.0, 1.0));
    default LandMeshComp.SetStaticMesh(LandMesh);
    default LandMeshComp.SetMaterial(0, LandMat);

    UPROPERTY()
    protected float LandMoveSpeed = 0.0;

    // float MoveSize = 336.0;
    // float OutOfRange = -336.0;

    // UFUNCTION(BlueprintOverride)
    // void BeginPlay()
    // {
    //     LandMeshComp.SetScalarParameterValueOnMaterials(n"LandMoveSpeed", LandMoveSpeed);
    // }

	void SetLandMoveSpeed(float Speed = 0.1)
	{
		LandMoveSpeed = Speed;
        LandMeshComp.SetScalarParameterValueOnMaterials(n"LandMoveSpeed", LandMoveSpeed);
	}

    // UFUNCTION(BlueprintOverride)
    // void Tick(float DeltaSeconds)
    // {
    // 	UpdateMove(DeltaSeconds);
    // }

    /**
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
     */
};