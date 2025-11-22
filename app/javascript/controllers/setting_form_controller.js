import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="setting-form"
export default class extends Controller {
  static targets = ["fieldType", "valueField"]

  connect() {
    // Update field type on load if field type is already set
    if (this.fieldTypeTarget.value) {
      this.updateFieldType()
    }
  }

  updateFieldType() {
    const fieldType = this.fieldTypeTarget.value
    const valueField = this.valueFieldTarget

    // Clear current content
    valueField.innerHTML = ""

    // Create label
    const label = document.createElement("label")
    label.className = "block text-sm font-medium text-primary-700 mb-2"
    label.textContent = "Value"
    valueField.appendChild(label)

    // Create appropriate input based on field type
    let input
    switch (fieldType) {
      case "boolean_field":
        const booleanContainer = document.createElement("div")
        booleanContainer.className = "flex items-center gap-4"

        const trueRadio = this.createRadioButton("true", "True", false)
        const falseRadio = this.createRadioButton("false", "False", true)

        booleanContainer.appendChild(trueRadio)
        booleanContainer.appendChild(falseRadio)
        valueField.appendChild(booleanContainer)
        break

      case "number_field":
        input = document.createElement("input")
        input.type = "number"
        input.name = "application_setting[value]"
        input.id = "application_setting_value"
        input.className = "w-full px-4 py-3 border border-secondary-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none transition-colors"
        input.placeholder = "0.00"
        input.step = "0.01"
        valueField.appendChild(input)
        break

      case "text_field":
        input = document.createElement("textarea")
        input.name = "application_setting[value]"
        input.id = "application_setting_value"
        input.className = "w-full px-4 py-3 border border-secondary-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none transition-colors"
        input.rows = 4
        input.placeholder = "Enter text value..."
        valueField.appendChild(input)
        break

      default:
        input = document.createElement("input")
        input.type = "text"
        input.name = "application_setting[value]"
        input.id = "application_setting_value"
        input.className = "w-full px-4 py-3 border border-secondary-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none transition-colors"
        input.placeholder = "Enter value..."
        valueField.appendChild(input)
    }
  }

  createRadioButton(value, labelText, checked) {
    const container = document.createElement("div")
    container.className = "flex items-center gap-2"

    const radio = document.createElement("input")
    radio.type = "radio"
    radio.name = "application_setting[value]"
    radio.id = `application_setting_value_${value}`
    radio.value = value
    radio.checked = checked
    radio.className = "w-4 h-4 text-primary-600 focus:ring-primary-500 border-secondary-300"

    const label = document.createElement("label")
    label.htmlFor = `application_setting_value_${value}`
    label.className = "text-sm font-medium text-primary-900"
    label.textContent = labelText

    container.appendChild(radio)
    container.appendChild(label)

    return container
  }
}

