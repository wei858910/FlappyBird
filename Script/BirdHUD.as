class ABirdHUD : AHUD
{
    UPROPERTY()
    protected UTexture NumTexture = nullptr;

    UPROPERTY()
    protected TArray<UTexture> NumberTextureArray;

    protected float NumberOffset = 24.0;

    protected ABirdGameState BirdGameState;

    protected float NumTextureHalfWidth = 12.0;
    protected float PositionY = 40.;

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
        DrawGameScore(SizeX, SizeY);
    }

    void DrawGameScore(int SizeX, int SizeY)
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

            float CenterX = SizeX / 2.0;

            if (Nums.Num() == 0)
            {
                DrawTextureSimple(NumberTextureArray[0], CenterX - NumTextureHalfWidth, PositionY);
            }
            else
            {
                for (int32 i = 0; i < NumSize; ++i)
                {
                    float DrawX = CenterX - (NumSize * NumberOffset)/2.0;
                    DrawTextureSimple(NumberTextureArray[Nums[NumSize - i - 1]], DrawX + i * NumberOffset, PositionY);
                }
            }
        }
    }
};