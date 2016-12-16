This is a simple plugin I developed for the project I am working at.

It takes a table (or anything containing table) and make pagination for it.

Options and defaults are:
* item_on_page: how much elements are on page (default 10)
* tr_class: if you want to page only certain classed tr you can write it here (default false)
* start_page: page starting from (default 1)
* page_next: element which will trigger moving forward on pagination navigation (default "#page_next")
* page_prev: element which will trigger moving backward on pagination navigation (default"#page_prev")
* page_cont: container for page links navigation to populate (default "#page_cont")
* page_template: template for creating page links (default `<li><a {trigger}>{num}</a></li>`)
* on_page_changed: function to be called when page is changed (default function(){})

Notes:
* The plugin will add classes for table's rows and hide/show them imitating pagination.
* If you pass tr_class it will count and hide/show only corresponding rows. Usefull when you are showing only odd or even rows with displaying the next row on click.
* When passing template you must use {trigger} and {num} in it. The first must be include in element tag the user will click, the second one just insert the number of page.
* It will add class 'active_page' to current page link in navigation
* JQuery is required to run this

Example:
* coffeescript:
    ```coffeescript

$(".table-order").makeMePaging({
    item_on_page: 10
    page_template: '<li class="pagination__item"><a href="javascript:void(0)" {trigger}>{num}</a></li>'
    on_page_changed: (i) ->
        $(".table-order__current").removeClass("table-order__current")
        $(".table-order__opentable").hide()
})

    ```
* html:
    ```html

<div class="table-order table-order_orders">
    <table>
        <thead>

        </thead>
        <tbody>
            <tr class="order_row table-order__current">
            </tr>
            <tr>
                <td class="table-order__subtable" colspan="11">
                    <table>
                        <thead>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        </tfoot>
                    </table>
                </td>
            </tr>
            <tr class="order_row table-order__current">
            </tr>
            <tr>
                <td class="table-order__subtable" colspan="11">
                    <table>
                        <thead>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        </tfoot>
                    </table>
                </td>
            </tr>
            <tr class="order_row table-order__current">
            </tr>
            <tr>
                <td class="table-order__subtable" colspan="11">
                    <table>
                        <thead>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        </tfoot>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
</div>

<div class="pagination pagination_left clearfix">
    <ul class="pagination__list clearfix">
        <li class="pagination__item"><a href="javascript:void(0)" id="page_prev"><svg class="icon icon-arrow-left"><use xlink:href="#icon-arrow-left"></use></svg></a></li>
    </ul>
    <ul class="pagination__list clearfix" id="page_cont">

    </ul>
    <ul class="pagination__list clearfix">
        <li class="pagination__item"><a href="javascript:void(0)" id="page_next"><svg class="icon icon-arrow-right"><use xlink:href="#icon-arrow-right"></use></svg></a></li>
    </ul>
</div>
    ```

It have small functionality but simple do the job.
