import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sale-calculator"
export default class extends Controller {
  static targets = [
    "productSelect",
    "sellingPrice",
    "quantity",
    "subtotal",
    "discountAmount",
    "taxAmount",
    "deliveryPartner",
    "deliveryCost",
    "total",
    "productInfo"
  ]

  connect() {
    // Load delivery partner costs if available
    this.loadDeliveryPartnerCosts()
    // Calculate initial values if form is pre-filled
    this.calculate()
  }

  updateProduct(event) {
    const productId = event.target.value
    if (productId) {
      const option = event.target.options[event.target.selectedIndex]
      const suggestedPrice = option.dataset.suggestedPrice
      const stock = option.dataset.stock
      const costPrice = option.dataset.costPrice

      // Auto-fill suggested selling price
      if (suggestedPrice) {
        this.sellingPriceTarget.value = parseFloat(suggestedPrice).toFixed(2)
      }

      // Update product info display
      if (this.hasProductInfoTarget) {
        const stockClass = parseFloat(stock) <= 1 ? 'text-accent-600' : ''
        this.productInfoTarget.innerHTML = `
          <p>Stock: <span class="font-medium ${stockClass}">${stock}</span></p>
          <p>Cost Price: Rs. ${parseFloat(costPrice).toLocaleString('en-IN', { minimumFractionDigits: 2 })}</p>
          <p>Suggested Price: Rs. ${parseFloat(suggestedPrice).toLocaleString('en-IN', { minimumFractionDigits: 2 })}</p>
        `
      }

      this.calculate()
    } else {
      if (this.hasProductInfoTarget) {
        this.productInfoTarget.innerHTML = ''
      }
      this.sellingPriceTarget.value = ''
      this.calculate()
    }
  }

  updateDeliveryCost(event) {
    const deliveryPartnerId = event.target.value
    if (deliveryPartnerId) {
      const option = event.target.options[event.target.selectedIndex]
      const defaultCost = option.dataset.defaultCost || 0
      this.deliveryCostTarget.value = parseFloat(defaultCost).toFixed(2)
    } else {
      this.deliveryCostTarget.value = "0.00"
    }
    this.calculate()
  }

  calculate() {
    const sellingPrice = parseFloat(this.sellingPriceTarget.value) || 0
    const quantity = parseFloat(this.quantityTarget.value) || 0
    const discountAmount = parseFloat(this.discountAmountTarget.value) || 0
    const taxAmount = parseFloat(this.taxAmountTarget.value) || 0
    const deliveryCost = parseFloat(this.deliveryCostTarget.value) || 0

    // Calculate subtotal
    const subtotal = (sellingPrice * quantity).toFixed(2)
    this.subtotalTarget.value = subtotal

    // Calculate total: subtotal - discount + tax + delivery
    const total = (parseFloat(subtotal) - discountAmount + taxAmount + deliveryCost).toFixed(2)
    this.totalTarget.value = total
  }

  loadDeliveryPartnerCosts() {
    // Add data attributes to delivery partner options if needed
    // This would be set in the view when rendering the select
  }
}

