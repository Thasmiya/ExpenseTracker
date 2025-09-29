class BudgetsController < ApplicationController
  before_action :authorize_request
  before_action :set_budget, only: [:show, :update, :destroy]

  def index
    budgets = @current_user.budgets.includes(:category)
    render json: budgets.as_json(include: :category)
  end

  def show
    render json: @budget.as_json(include: :category)
  end

  def create
    budget = @current_user.budgets.new(budget_params)
    if budget.save
      render json: budget, status: :created
    else
      render json: { errors: budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @budget.update(budget_params)
      render json: @budget
    else
      render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy
    head :no_content
  end

  private

  def set_budget
    @budget = @current_user.budgets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Budget not found'] }, status: :not_found
  end

  def budget_params
    params.require(:budget).permit(:limit, :period, :category_id)
  end
end
