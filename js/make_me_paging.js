// Generated by CoffeeScript 1.10.0
(function() {
  (function($, window) {
    return $.extend($.fn, {
      makeMePaging: function(options) {
        var settings;
        this.defaultOptions = {
          item_on_page: 10,
          tr_class: false,
          start_page: 1,
          page_navigation: "#page_navigation",
          page_next: "#page_next",
          page_prev: "#page_prev",
          page_cont: "#page_cont",
          page_template: "<li><a {trigger}>{num}</a></li>",
          on_page_changed: function() {}
        };
        settings = $.extend({}, this.defaultOptions, options);
        this.show_page = function(i, el) {
          $(el).find(".pager_item").hide();
          $(el).find(".page" + i).show();
          $(el).attr("current_page", i);
          $(".active_page").removeClass("active_page");
          $("[page_num='" + i + "']").addClass("active_page");
          return settings.on_page_changed.call(i);
        };
        this.populate_page_cont = function(elem_count, elem_cont, el) {
          var el_num, i, num;
          $(elem_cont).empty();
          i = 0;
          while (i < elem_count) {
            num = settings.page_template;
            num = num.replace("{num}", i + 1).replace("{trigger}", "pager_trigger page_num='" + (i + 1) + "'");
            el_num = $(num);
            $(elem_cont).append(el_num);
            i = i + 1;
          }
          $(elem_cont).find("[pager_trigger]").unbind();
          return $(elem_cont).find("[pager_trigger]").click((function(_this) {
            return function(event) {
              var page_num;
              page_num = $(event.currentTarget).attr("page_num");
              return _this.show_page(page_num, el);
            };
          })(this));
        };
        this.next_page = function(el) {
          var cp, pc;
          cp = $(el).attr("current_page");
          pc = $(el).attr("page_count");
          if (cp * 1 < pc * 1) {
            return this.show_page(cp * 1 + 1, el);
          }
        };
        this.prev_page = function(el) {
          var cp;
          cp = $(el).attr("current_page");
          if (cp * 1 > 1) {
            return this.show_page(cp * 1 - 1, el);
          }
        };
        this.each((function(_this) {
          return function(i, el) {
            var $el, page_count, page_number, tr_list, tr_string;
            $el = $(el);
            $(el).attr("current_page", settings.start_page);
            if (settings.tr_class !== false) {
              tr_string = "tr." + settings.tr_class;
            } else {
              tr_string = "tr";
            }
            tr_list = $(el).find("tbody").find(tr_string);
            page_count = Math.ceil($(tr_list).size() / settings.item_on_page);
            $(el).attr("page_count", page_count);
            _this.populate_page_cont(page_count, settings.page_cont, el);
            page_number = 0;
            $(tr_list).each(function(i2, el2) {
              if ((i2 % settings.item_on_page) === 0) {
                page_number = page_number + 1;
              }
              $(el2).addClass("page" + page_number);
              return $(el2).addClass("pager_item");
            });
            _this.show_page(settings.start_page, el);
            $(settings.page_next).unbind();
            $(settings.page_next).click(function() {
              return _this.next_page(el);
            });
            $(settings.page_prev).unbind();
            return $(settings.page_prev).click(function() {
              return _this.prev_page(el);
            });
          };
        })(this));
        return this;
      }
    });
  })(this.jQuery || this.Zepto, this);

}).call(this);
