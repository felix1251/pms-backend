class API::V2::SupportChatsController < ApplicationController
  before_action :set_support_chat, only: [:show, :update, :destroy]

  # GET /support_chats
  def index
    @support_chats = SupportChat.all

    render json: @support_chats
  end

  # GET /support_chats/1
  def show
    render json: @support_chat
  end

  # POST /support_chats
  def create
    @support_chat = SupportChat.new(support_chat_params)

    if @support_chat.save
      render json: @support_chat, status: :created, location: @support_chat
    else
      render json: @support_chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /support_chats/1
  def update
    if @support_chat.update(support_chat_params)
      render json: @support_chat
    else
      render json: @support_chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /support_chats/1
  def destroy
    @support_chat.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_support_chat
      @support_chat = SupportChat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def support_chat_params
      params.require(:support_chat).permit(:encrypted_message, :encrypted_message_iv, :encrypted_message_salt, :user_id, :admin_id)
    end
end
