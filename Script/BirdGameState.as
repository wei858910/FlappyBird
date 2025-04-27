class ABirdGameState : AGameState
{
    UPROPERTY()
    USoundWave CoinSound;

    protected int32 Score = 0;

    void AddScore()
    {
        Score++;

        if (!IsValid(CoinSound))
        {
            CoinSound = Cast<USoundWave>(LoadObject(nullptr, "/Game/Sounds/coin.coin"));
        }

        if (IsValid(CoinSound))
        {
            Gameplay::PlaySound2D(CoinSound);
        }
    }

    const int32 GetScore()
    {
        return Score;
    }

    void ResetScore()
    {
        Score = 0;
    }

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
    }
};