window.AmPmModifier = {
  convert24to12: function(hour) {
    if (hour == 0) return 12;
    if (hour == 12) return 12;
    return hour % 12;
  },

  initialize: function(hourSelector, amPmSelect) {
    this.hourSelector = $(hourSelector || '#event_start_5i');
    this.amPmSelect = $(amPmSelect || '#event_start_ampm');
    removeAmPmFromHours();
    setUpToggleEvent();
  },

  removeAmPmFromHours: function() {
    var selectedHour = this.hourSelector.val(); // Save the already-selected hour

    // Replace options with 12 hour versions
    var twelveHourOptions = "";
    for (var i = 0; i < 12; i++) {
      twelveHourOptions = twelveHourOptions.concat('<option value="' + i + '" data-original="' + i + '">' + convert24to12(i) + '</option>');
    }
    this.hourSelector.html(twelveHourOptions);

    // Select the correct option
    this.hourSelector.val(selectedHour % 12);
    this.amPmSelect.val(Math.floor(selectedHour / 12)); // am: 1, pm: 1
  },

  setUpToggleEvent: function() {
    var amPm = $(this.amPmSelect);
    amPm.change(function() {
      var currentValue = amPm.val();
      var modifier = 12 * Integer.parseInt(currentValue);
      this.hourSelector.find('option').each(function() {
        var option = $(this);
        var originalVal = option.data('original');
        option.val(modifier + originalVal);
      });
    });
  }
}

AmPmModifier.initialize()
