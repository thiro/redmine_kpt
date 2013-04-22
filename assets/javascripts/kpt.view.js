/*
 * KptBoard
 */
(function($) {

  $.fn.KptBoard = function(kpt_options) {
    var Options = $.extend({ url: null }, kpt_options);
    var Title = this.find("h2 > span.title");
    var Form = this.find("#new_kpt_entry");
    var Input = Form.find("#kpt_entry_description");
    var Queue = this.find("#kpt_queue");
    var Entries = this.find("#kpt_entries");
    var Warning = this.find(".warning");
    var Menu = {
      Edit:    this.find("#kpt_menu a.edit"),
      Lock:    this.find("#kpt_menu a.lock"),
      Unlock:  this.find("#kpt_menu a.unlock"),
      Online:  this.find("#kpt_menu a.online"),
      Offline: this.find("#kpt_menu a.offline"),
      Delete:  this.find("#kpt_menu a.delete")
    };
    var Updater = null;

    var Distribute = function(animate) {
      $.each(["keep","problem","try"], function(index, kind) {
        var items = $(Queue.find("li."+kind).detach().get().reverse());
        items.hide().prependTo(Entries.find("div."+kind+" ul"));
        if(animate)
          items.show("drop", { direction:"up" });
        else
          items.show();
      });
    }

    var CreateUpdater = function(url) {
      return $.PeriodicalUpdater(url+'/entries', {
        data: function() { return { from: Entries.find("li").length } },
        dataType: "script", //dataType: "html",
        minTimeout: 2000,
        maxTimeout: 15000,
        multiplier: 2,
        success: function() { },
        error: function(result) { } // guess the kpt has removed on result.status == 404
      });
    }

    var BindAjaxEvents = function() {
      Form
        .bind("ajax:beforeSend", function() {
          if(Input.val().length < 3) {
            Form.effect("shake");
            return false;
          } else {
            $("#ajax-indicator").show();
            Updater.stop();
          } })
        .bind("ajax:complete", function() { $("#ajax-indicator").hide(); })
        .bind("ajax:success", function(event, data, status, xhr) { Updater.restart(); })
        .bind("ajax:error", function() { })
        .bind("ajaxSuccess", function() { $(this).find("input").removeAttr("disabled"); })
        .bind("ajaxError", function(me, info) {
          if(info.statusText != "canceled")
            $(this).find("input").attr("disabled", "disabled");
        });
      $("#errorExplanation")
        .bind("ajaxSuccess", function() { $(this).hide("blind", { direction: "vertical" }); })
        .bind("ajaxError", function(me, info) {
          if(info.statusText != "canceled") {
            $(this).show("blind", { direction: "vertical" });
            Updater.stop();
            Menu.Online.show();
            Menu.Offline.hide();
          } });
    }

    // construct
    //Form.find("input[type=radio]").css("opacity","0"); // hidden raddio button hack
    Form.find("label").click(function() { Input.focus(); });
    Distribute(false);
    BindAjaxEvents();
    Updater = CreateUpdater(Options.url);
    Updater.stop();

    // return handler
    return {
      setup: function(locked, participate) {
        $.each(Menu, function(key, value) { value.show(); });
        if(locked) {
          this.offline();
          this.formLock();
        } else {
          this.online();
          if(participate)
            this.formUnlock();
        }
        return this;
      },

      draw: function(html) {
        if(html)
          Queue.append(html);
        Distribute(true);
        return this;
      },

      title: function(html) {
        if(html && (Title.html() != html))
          Title.hide().html(html).show("normal");
        return this;
      },

      formUnlock: function () {
        Form.parent().show("blind", { direction: "vertical" });
        Menu.Lock.show();
        Menu.Unlock.hide();
        this.online();
        return this;
      },

      formLock: function () {
        Form.parent().hide("blind", { direction: "vertical" });
        Warning.hide("blind", { direction: "vertical" });
        Menu.Lock.hide();
        Menu.Unlock.show();
        this.offline();
        return this;
      },

      formClear: function() {
        Input.val("").focus();
        return this;
      },

      formShake: function() {
        Form.effect("shake");
        Input.select().focus();
        return this;
      },

      online: function(interval) {
        if(interval)
          Updater.restart(interval);
        else
          Updater.restart();
        Menu.Online.hide();
        Menu.Offline.show();
        return this;
      },

      offline: function() {
        Updater.stop();
        Menu.Online.show();
        Menu.Offline.hide();
        return this;
      },

      sync: function() {
        Updater.send();
        return this;
      },

      warning: function(html) {
        if(!html || html === "")
          Warning.hide("blind", { direction: "vertical" });
        else
          Warning.html(html).show("blind", { direction: "vertical" });
        return this;
      },

      // for debugging
      debug: function() {
        this.Form = Form;
        this.Menu = Menu;
        this.Updater = Updater;
        return this;
      }
    }
  }

})(jQuery);
