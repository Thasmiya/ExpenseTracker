class ReportsController < ApplicationController
  before_action :authorize_request

  # GET /reports/monthly?year=2025&month=9
  def monthly
    year = params[:year].to_i.nonzero? || Date.today.year
    month = params[:month].to_i.nonzero? || Date.today.month
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    results = @current_user.expenses
      .where(date: start_date..end_date)
      .joins(:category)
      .group('categories.name')
      .sum(:amount)

    render json: { period: "#{start_date} - #{end_date}", by_category: results }
  end

  # GET /reports/weekly?start=2025-09-01
  def weekly
    start_date = params[:start].present? ? Date.parse(params[:start]) : Date.today.beginning_of_week
    end_date = start_date.end_of_week

    results = @current_user.expenses
      .where(date: start_date..end_date)
      .joins(:category)
      .group('categories.name')
      .sum(:amount)

    render json: { period: "#{start_date} - #{end_date}", by_category: results }
  end

  # GET /reports/budget_status
  def budget_status
    # Default monthly status for all budgets
    today = Date.today
    start_date = today.beginning_of_month
    end_date = today.end_of_month

    budgets = @current_user.budgets.includes(:category)
    status = budgets.map do |b|
      spent = @current_user.expenses.where(category_id: b.category_id, date: start_date..end_date).sum(:amount)
      { budget_id: b.id, category: b.category.name, limit: b.limit.to_f, spent: spent.to_f, remaining: (b.limit - spent).to_f }
    end

    render json: { period: "#{start_date} - #{end_date}", budgets: status }
  end
end
