class ExpensesController < AuthenticatedController
  before_action :set_expense, only: %i[show edit update destroy]

  def index
    @q = Expense.ransack(params[:q])
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    @pagy, @expenses = pagy(@q.result, items: 20)
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to expenses_path, notice: "Expense was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Expense was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense was successfully deleted."
  end

  private

  def set_expense
    @expense = Expense.find_by_obfuscated_id(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:category, :amount, :description)
  end
end
