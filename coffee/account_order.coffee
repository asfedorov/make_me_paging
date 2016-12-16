get_user_info = () ->
    user_info_cont = $("div#user_info")
    user_uid = $(user_info_cont).find(".uid").html()
    user_counterparty_cont = $(user_info_cont).find(".counterparty_list")

    counterparty_list = []
    $(user_counterparty_cont).find(".c_container").each (i, el) =>
        c = {
            "name": $(el).find(".c_name").html(),
            "balance": $(el).find(".c_balance").html(),
        }

        counterparty_list.push(c)

    LK_App["user_info"] = {
        "uid": user_uid,
        "counterparty_list": counterparty_list
    }


fill_da_table = (json) ->
    $(".trimet_preloader").hide()
    table_obj = $(".table-order").find("tbody")

    table_obj.html ""

    for v in json.order_list
        if v.responsible is "None"
            v.responsible = "---"
        new_row = """
            <tr uid="#{v.uid}" class="order_row">
                <td class="id"></td>
                <td class="date">#{v.datetime}</td>
                <td class="number_order">#{v.number}</td>
                <td class="table-order__left">#{v.status}</td>
                <td class="table-order__link"><a href="javascript:void(0)">#{v.responsible}</a></td>
                <td>#{v.counterparty}</td>
                <td class="table-order__bold">30</td>
                <td class="table-order__bold">0</td>
                <td class="table-order__bold table-order__nowrap">#{v.sum}</td>
                <td class="table-order__file table-order__left table-order__nowrap table-order__link">
                    <a href="javascript:void(0)"><svg class="icon icon-download"><use xlink:href="#icon-download"></use></svg>Выставочный счет</a>
                    <a href="javascript:void(0)"><svg class="icon icon-download"><use xlink:href="#icon-download"></use></svg>Файл резки</a>
                </td>
                <td class="table-order__button table-order__link"><a href="javascript:void(0)">Оплатить</a></td>

            </tr>
        """
        $(table_obj).append(new_row)

    $(".order_row").click ->
        currentTable = 'table-order__current'

        action = "open"
        if $(this).hasClass(currentTable)
            action = "close"
            $(this).removeClass(currentTable)
        else
            $(".#{currentTable}").removeClass(currentTable)
            $(this).addClass(currentTable)
        # console.log "hello"
        $(".table-order__opentable").hide()

        next = $(this).next()
        if $(next).hasClass("table-order__opentable")
            if action is "open"
                $(next).show()
            else
                $(next).hide()
        else
            load_order_data($(this).attr("uid"))


    # $(".table-order").unbind()
    $(".table-order").makeMePaging({
        item_on_page: 10
        page_template: '<li class="pagination__item"><a href="javascript:void(0)" {trigger}>{num}</a></li>'
        on_page_changed: (i) ->
            $(".table-order__current").removeClass("table-order__current")
            $(".table-order__opentable").hide()
    })

fill_da_order = (json, uid) ->
    console.log uid
    subtable_start = """
        <tr class="table-order__opentable">
            <td class="table-order__subtable" colspan="11">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Номенклатура</th>
                            <th>ХАрактеристика</th>
                            <th>Количество</th>
                            <th>ед. изм.</th>
                            <th>Цена, руб.</th>
                            <th>Ставка НДС</th>
                            <th>Сумма НДС, руб.</th>
                            <th>Сумма с НДС, руб.</th>
                            </tr>
                        </thead>
                        <tbody>"""
    tbody = ""
    for v in json.lines
        new_row = """
            <tr>
                <td>#{v.line_number}</td>
                <td class="table-order__left">#{v.good}</td>
                <td>#{v.char}</td>
                <td>#{v.amount}</td>
                <td>#{v.ed_izm}</td>
                <td>30</td>
                <td>#{v.nds}</td>
                <td>#{v.sum_nds}</td>
                <td>#{v.sum}</td>
            </tr>
        """
        tbody = tbody + new_row

    subtable_end = """</tbody>
                        <tfoot>
                            <tr>
                                <td class="table-order__bold table-order__left" colspan="3">Итого</td>
                                <td class="table-order__nowrap table-order__bold">3.8007</td>
                                <td colspan="3"></td>
                                <td class="table-order__nowrap table-order__bold">9 600.00</td>
                                <td class="table-order__nowrap table-order__bold">63 800.00</td>
                            </tr>
                            <tr>
                                <td class="table-order__left table-order__footer" colspan="9">
                                    Вы можете:<a class="table-order__button-cancel" href="javscript:void(0)">Отменить заказ</a>или<a class="table-order__button-order" href="javascript:void(0)">повторить заказ</a>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </td>
            </tr>
        """

    subtable = subtable_start + tbody + subtable_end

    c_tr = $(".order_row[uid='#{uid}']")

    $(subtable).insertAfter(c_tr)


load_data = () ->
    range = $(".datepicker").val()
    console.log range
    range_ar = range.split(" - ")
    from = range_ar[0]
    to = range_ar[1]

    from = from.split(".")[2] + "-" + from.split(".")[1] + "-" + from.split(".")[0]
    to = to.split(".")[2] + "-" + to.split(".")[1] + "-" + to.split(".")[0]

    $.ajax
        type: "GET",
        url: "/extscripts/get_order_list_json.py",
        async: true,
        data: "UID=#{LK_App.user_info.uid}&date_from=#{from}&date_to=#{to}",
        success: (html) ->

            fill_da_table html

            if LK_App.data_first_loaded is false
                after_first_load()


load_order_data = (uid) ->
    console.log "load order data #{uid}"
    $.ajax
        type: "GET",
        url: "/extscripts/get_tab_part_order_json.py",
        async: true,
        data: "UID=#{uid}",
        success: (html) =>

            fill_da_order html, uid


after_first_load = () ->
    LK_App.data_first_loaded = true
    $(".datepicker").change ->
        load_data()


$(document).ready ->
    get_user_info()

    console.log LK_App.user_info

    LK_App.data_first_loaded = false


    table_order = $(".table-order").find("table")

    $(table_order).find("tbody").append("""
        <tr class="trimet_preloader">
            <td colspan=11 style='text-align:center;'>
                <img alt='loading...' src='/local/templates/trimet-lk/images/preloader-lk.gif' />
            </td>
        </tr>
    """)

    load_data()

    $(".order_row").find(".number_order").click ->
        console.log "hello"
        load_order_data($(this).closest("tr").attr("uid"))
