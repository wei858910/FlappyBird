class ABirdHUD : AHUD
{
    UPROPERTY()
    protected UTexture NumTexture = nullptr;

    UPROPERTY()
    protected TArray<UTexture> NumberTextureArray;

    protected float NumberOffset = 24.;

    protected ABirdGameState BirdGameState;

    protected float NumTextureHalfWidth = 12.;
    protected float PositionY = 40.;

    protected float FadeSpeed = 10;
    protected float FadeAlphaValue = 0.;
    protected bool bFade = false;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        NumTexture = Cast<UTexture>(LoadObject(nullptr, "/Game/Textures/Numbers/font_048.font_048"));

        for (int32 i = 48; i < 58; i++)
        {
            FString TexturePath = f"/Game/Textures/Numbers/font_0{i}.font_0{i}";
            NumTexture = Cast<UTexture>(LoadObject(nullptr, TexturePath));
            NumberTextureArray.Add(NumTexture);
        }
    }

    UFUNCTION(BlueprintOverride)
    void DrawHUD(int SizeX, int SizeY)
    {
        // DrawTextureSimple(NumTexture, 200, 200);
        // DrawTexture(NumTexture, 200, 200, 50, 100, 0, 0, 1, 1, FLinearColor::White, EBlendMode::BLEND_Opaque, 1, false, 45, FVector2D(0.5, 0.5));
        UpdateScreeFade(SizeX, SizeY);
        DrawGameScore(SizeX, SizeY);
    }

    protected void DrawGameScore(int SizeX, int SizeY)
    {
        if (!IsValid(BirdGameState))
        {
            BirdGameState = Cast<ABirdGameState>(Gameplay::GetGameState());
        }

        if (IsValid(BirdGameState))
        {
            // FString Score = f"{BirdGameState.GetScore()}";
            // DrawText(Score, FLinearColor::Red, 100, 100);

            int32 Score = BirdGameState.GetScore();

            Log(f"Score = {Score}");

            TArray<int32> Nums;
            while (Score != 0)
            {
                Nums.Add(Score % 10);
                Score /= 10;
            }

            int32 NumSize = Nums.Num();

            float CenterX = SizeX / 2.;

            if (Nums.Num() == 0)
            {
                DrawTextureSimple(NumberTextureArray[0], CenterX - NumTextureHalfWidth, PositionY);
            }
            else
            {
                for (int32 i = 0; i < NumSize; ++i)
                {
                    float DrawX = CenterX - (NumSize * NumberOffset) / 2.;
                    DrawTextureSimple(NumberTextureArray[Nums[NumSize - i - 1]], DrawX + i * NumberOffset, PositionY);
                }
            }
        }
    }

    protected void UpdateScreeFade(int SizeX, int SizeY)
    {
        if (bFade)
        {
            FadeAlphaValue += (FadeSpeed * Gameplay::GetWorldDeltaSeconds());
            DrawRect(FLinearColor(1., 1., 1., FadeAlphaValue), 0., 0., SizeX, SizeY);
            if (FadeAlphaValue > 1 || FadeAlphaValue < 0)
            {
                FadeSpeed *= -1.;
            }

            bFade = !(FadeAlphaValue < 0);
        }
    }

    void StartScreeFade()
    {
        bFade = true;
        FadeAlphaValue = 0.;
    }
};