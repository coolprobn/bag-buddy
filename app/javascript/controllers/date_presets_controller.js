import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-presets"
export default class extends Controller {
  static targets = ["startDate", "endDate"]

  connect() {
    // Listen for manual date changes
    if (this.hasStartDateTarget) {
      this.startDateTarget.addEventListener("change", () => this.handleDateChange())
    }
    if (this.hasEndDateTarget) {
      this.endDateTarget.addEventListener("change", () => this.handleDateChange())
    }
  }

  handlePresetChange(event) {
    const preset = event.target.value

    if (preset === "custom") {
      // Don't auto-populate for custom, let user select dates manually
      return
    }

    if (!this.hasStartDateTarget || !this.hasEndDateTarget) {
      return
    }

    const dateRange = this.calculateDateRange(preset)

    if (dateRange.startDate && dateRange.endDate) {
      this.startDateTarget.value = dateRange.startDate
      this.endDateTarget.value = dateRange.endDate
    }
  }

  handleDateChange() {
    // If user manually changes dates, switch to custom preset
    const presetSelect = this.element.querySelector('select[name="date_preset"]')
    if (presetSelect && presetSelect.value !== "custom") {
      presetSelect.value = "custom"
    }
  }

  calculateDateRange(preset) {
    const today = new Date()
    let startDate, endDate

    switch (preset) {
      case "today":
        startDate = endDate = this.formatDate(today)
        break

      case "this_week":
        startDate = this.formatDate(this.getStartOfWeek(today))
        endDate = this.formatDate(this.getEndOfWeek(today))
        break

      case "last_week":
        const lastWeek = new Date(today)
        lastWeek.setDate(today.getDate() - 7)
        startDate = this.formatDate(this.getStartOfWeek(lastWeek))
        endDate = this.formatDate(this.getEndOfWeek(lastWeek))
        break

      case "this_month":
        startDate = this.formatDate(new Date(today.getFullYear(), today.getMonth(), 1))
        endDate = this.formatDate(new Date(today.getFullYear(), today.getMonth() + 1, 0))
        break

      case "last_month":
        const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1)
        startDate = this.formatDate(lastMonth)
        endDate = this.formatDate(new Date(today.getFullYear(), today.getMonth(), 0))
        break

      case "this_quarter":
        const quarter = Math.floor(today.getMonth() / 3)
        startDate = this.formatDate(new Date(today.getFullYear(), quarter * 3, 1))
        endDate = this.formatDate(new Date(today.getFullYear(), (quarter + 1) * 3, 0))
        break

      case "last_quarter":
        const currentQuarter = Math.floor(today.getMonth() / 3)
        const lastQuarter = currentQuarter === 0 ? 3 : currentQuarter - 1
        const lastQuarterYear = currentQuarter === 0 ? today.getFullYear() - 1 : today.getFullYear()
        const lastQuarterMonth = lastQuarter * 3
        startDate = this.formatDate(new Date(lastQuarterYear, lastQuarterMonth, 1))
        endDate = this.formatDate(new Date(lastQuarterYear, lastQuarterMonth + 3, 0))
        break

      case "last_6_months":
        const sixMonthsAgo = new Date(today)
        sixMonthsAgo.setMonth(today.getMonth() - 6)
        startDate = this.formatDate(sixMonthsAgo)
        endDate = this.formatDate(today)
        break

      case "this_year":
        startDate = this.formatDate(new Date(today.getFullYear(), 0, 1))
        endDate = this.formatDate(new Date(today.getFullYear(), 11, 31))
        break

      case "last_year":
        startDate = this.formatDate(new Date(today.getFullYear() - 1, 0, 1))
        endDate = this.formatDate(new Date(today.getFullYear() - 1, 11, 31))
        break

      case "all_time":
        startDate = "2000-01-01"
        endDate = this.formatDate(today)
        break

      default:
        // Default to this month
        startDate = this.formatDate(new Date(today.getFullYear(), today.getMonth(), 1))
        endDate = this.formatDate(new Date(today.getFullYear(), today.getMonth() + 1, 0))
    }

    return { startDate, endDate }
  }

  formatDate(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, "0")
    const day = String(date.getDate()).padStart(2, "0")
    return `${year}-${month}-${day}`
  }

  getStartOfWeek(date) {
    const d = new Date(date)
    const day = d.getDay()
    const diff = d.getDate() - day + (day === 0 ? -6 : 1) // Adjust when day is Sunday
    return new Date(d.setDate(diff))
  }

  getEndOfWeek(date) {
    const start = this.getStartOfWeek(date)
    const end = new Date(start)
    end.setDate(start.getDate() + 6)
    return end
  }
}

