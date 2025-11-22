import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="price-calculator"
export default class extends Controller {
  static targets = ["costPrice", "suggestedPrice"]
  static values = { markupPercentage: Number }

  connect() {
    // Calculate initial price if cost price already has a value
    if (this.costPriceTarget.value) {
      this.calculate()
    }
  }

  calculate() {
    const costPrice = parseFloat(this.costPriceTarget.value) || 0
    
    if (costPrice > 0) {
      const suggestedPrice = costPrice * (1 + this.markupPercentageValue / 100)
      this.suggestedPriceTarget.value = suggestedPrice.toFixed(2)
    } else {
      this.suggestedPriceTarget.value = ''
    }
  }
}

