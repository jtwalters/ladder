require "test_helper"

describe Game do
  before do
    @game = create(:game)
    @player1 = create(:player)
    @player2 = create(:player)
    @user1 = @player1.user
    @user2 = @player2.user
    @game_rank1 = create(:game_rank, :game => @game, :player => @player1, :position => 1)
    @game_rank2 = create(:game_rank, :game => @game, :player => @player2, :position => 2)
  end

  describe ".destroy" do
    it "must destroy descendent game ranks" do
      @game.destroy
      GameRank.where(:game_id => @game.id).count.must_equal 0
    end
  end

  describe ".participant" do
    it "must match participant" do
      Game.participant(@user1).must_include @game
      Game.participant(@user2).must_include @game
    end

    it "wont match nonparticipant" do
      @user = create(:user)
      Game.participant(@user).wont_include @game
    end
  end

  describe "#confirm_user" do
    it "must confirm the users rank" do
      @game.confirm_user(@user1)
      @game_rank1.reload.confirmed?.must_equal true
    end

    it "wont confirm other users rank" do
      @game.confirm_user(@user1)
      @game_rank2.reload.confirmed?.wont_equal true
    end

    it "must return true when game is confirmed" do
      @game.confirm_user(@user1).wont_equal true
      @game.confirm_user(@user2).must_equal true
    end

    describe "streaks" do
      it "must increment players winning/losing streaks when game is confirmed" do
        @player1.update_attributes :winning_streak_count => 5, :losing_streak_count => 0
        @player2.update_attributes :winning_streak_count => 0, :losing_streak_count => 5
        @game.confirm_user(@user1)
        @game.confirm_user(@user2)
        @player1.reload.winning_streak_count.must_equal 6
        @player1.reload.losing_streak_count.must_equal 0
        @player2.reload.winning_streak_count.must_equal 0
        @player2.reload.losing_streak_count.must_equal 6
      end

      it "must reset players winning/losing streaks when game is confirmed" do
        @player1.update_attributes :winning_streak_count => 0, :losing_streak_count => 5
        @player2.update_attributes :winning_streak_count => 5, :losing_streak_count => 0
        @game.confirm_user(@user1)
        @game.confirm_user(@user2)
        @player1.reload.winning_streak_count.must_equal 1
        @player1.reload.losing_streak_count.must_equal 0
        @player2.reload.winning_streak_count.must_equal 0
        @player2.reload.losing_streak_count.must_equal 1
      end

      it "must reset all streaks when game is a draw" do
        @game_rank2.update_attributes :position => 1
        @player1.update_attributes :winning_streak_count => 5, :losing_streak_count => 0
        @player2.update_attributes :winning_streak_count => 5, :losing_streak_count => 0
        @game.confirm_user(@user1)
        @game.confirm_user(@user2)
        @player1.reload.winning_streak_count.must_equal 0
        @player1.reload.losing_streak_count.must_equal 0
        @player2.reload.winning_streak_count.must_equal 0
        @player2.reload.losing_streak_count.must_equal 0
      end
    end
  end

  describe "#confirmed?" do
    it "must be true when confirmed_at is not nil" do
      @game.confirmed_at = Time.zone.now
      @game.confirmed?.must_equal true
    end

    it "wont be true when confirmed_at is nil" do
      @game.confirmed_at = nil
      @game.confirmed?.wont_equal true
    end
  end
end
