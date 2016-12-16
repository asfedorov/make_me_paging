# Plugin MakeMePaging
# By Alexander Fedorov 2016
#
# This will take a table and make slice it to pages.
# Slicing every class-specified tr is supported
#
# License: MIT

# Started from https://github.com/alanhogan/Coffeescript-jQuery-Plugin-Template

(($, window) ->
    $.extend $.fn, makeMePaging: (options) ->
        @defaultOptions =
            item_on_page: 10
            tr_class:  false
            start_page: 1
            page_navigation: "#page_navigation"
            page_next: "#page_next"
            page_prev: "#page_prev"
            page_cont: "#page_cont"
            page_template: "<li><a {trigger}>{num}</a></li>"
            on_page_changed: () ->

        settings = $.extend({}, @defaultOptions, options)

        @show_page = (i, el) ->
            $(el).find(".pager_item").hide()
            $(el).find(".page#{i}").show()
            $(el).attr("current_page", i)

            $(".active_page").removeClass("active_page")
            $("[page_num='#{i}']").addClass("active_page")
            settings.on_page_changed.call( i );

        @populate_page_cont  = (elem_count, elem_cont, el) ->
            # console.log settings
            $(elem_cont).empty()
            i = 0
            while i < elem_count
                num = settings.page_template
                num = num.replace("{num}", i+1).replace("{trigger}", "pager_trigger page_num='#{i+1}'")
                el_num = $(num)
                # $(el_num).addClass("pager_trigger")
                $(elem_cont).append(el_num)
                i = i + 1

            $(elem_cont).find("[pager_trigger]").unbind()
            $(elem_cont).find("[pager_trigger]").click (event) =>
                # console.log "i am clicked"
                page_num = $(event.currentTarget).attr("page_num")
                # console.log page_num
                @show_page(page_num, el)

        @next_page = (el) ->
            cp = $(el).attr("current_page")
            pc = $(el).attr("page_count")

            if cp*1 < pc*1
                @show_page(cp*1+1, el)

        @prev_page = (el) ->
            cp = $(el).attr("current_page")

            if cp*1 > 1
                @show_page(cp*1-1, el)

        # Code here will run each time your plugin is invoked

        @each (i, el) =>
            $el = $(el) # If you need it!

            $(el).attr("current_page", settings.start_page)
            if settings.tr_class != false
                tr_string = "tr.#{settings.tr_class}"
            else
                tr_string = "tr"
            tr_list = $(el).find("tbody").find(tr_string)

            page_count = Math.ceil($(tr_list).size() / settings.item_on_page)
            $(el).attr("page_count", page_count)

            # console.log settings.page_cont
            @populate_page_cont(page_count, settings.page_cont, el)

            page_number = 0
            $(tr_list).each (i2, el2) =>
                if (i2 % settings.item_on_page) == 0
                    page_number = page_number + 1
                $(el2).addClass("page#{page_number}")
                $(el2).addClass("pager_item")

            @show_page(settings.start_page, el)

            $(settings.page_next).unbind()
            $(settings.page_next).click =>
                @next_page(el)

            $(settings.page_prev).unbind()
            $(settings.page_prev).click =>
                @prev_page(el)

            # Code here will run once for each member of the jQuery collection on which your plugin was invoked
            
            # Careful - if the last executed statement in this "each" function evaluates to false, 
            # you will stop iterating over the collection.
        
        @ # allow chaining
) this.jQuery or this.Zepto, this