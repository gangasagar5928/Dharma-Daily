name: 🐛 Bug Report
description: Create a report to help us fix a bug or panchang calculation error
title: "[BUG]: "
labels: ["bug"]
assignees: ["gangasagar5928"]
body:
  - type: markdown
    attributes:
      value: Thanks for helping improve Dharma Daily!
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: Clear and concise description of what the bug is or which panchang/shloka text is incorrect.
    validations:
      required: true
  - type: dropdown
    id: area
    attributes:
      label: Component Area
      options:
        - "Panchang / Ephemeris Calculation"
        - "Scripture Reader (Gita, Sutras)"
        - "Vedas & Purans Offline Text"
        - "Google Drive PDF Reader"
        - "Notifications / Reminders"
        - "UI / Design System / Theme"
    validations:
      required: true
  - type: textarea
    id: reproduction
    attributes:
      label: Steps to Reproduce
      description: Steps to reproduce the behavior.
      placeholder: |
        1. Open 'Panchang Calendar'
        2. Select date '...'
        3. See error
    validations:
      required: true
  - type: input
    id: device
    attributes:
      label: Device / OS Version
      placeholder: "e.g. Samsung Galaxy S23, Android 14"
