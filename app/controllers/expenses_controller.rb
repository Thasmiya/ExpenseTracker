class ExpensesController < ApplicationController
  before_action :authorize_request
  before_action :set_expense, only: [:show, :update, :destroy]

  def index
    expenses = @current_user.expenses.includes(:category).order(date: :desc)
    render json: expenses.as_json(include: :category)
  end

  def show
    render json: @expense.as_json(include: :category)
  end

  def create
    expense = @current_user.expenses.new(expense_params)
    if expense.save
      render json: expense, status: :created
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head :no_content
  end

  private

  def set_expense
    @expense = @current_user.expenses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Expense not found'] }, status: :not_found
  end

  def expense_params
    params.require(:expense).permit(:amount, :date, :payment_method, :notes, :category_id)
  end
end
