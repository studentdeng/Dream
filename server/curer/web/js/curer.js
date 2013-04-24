var mainUrl = 'http://192.168.1.200/curer/';

$(document).ready(function() {

    $('#myTab a').click(function(e) {
        e.preventDefault();

        if (e.target == mainUrl + 'web/#progress')
        {
            startPaging();
        }
        else if (e.target == mainUrl + 'web/#evaluation')
        {
            submitEvaluation();
        }

        $(this).tab('show');
    })
});

function submitAdd() {
    var selectPlanId = $('#selectPlanId').val();
    var costTimeMin = $('#costTimeMin').val();

    var url = mainUrl + 'index.php/api/progress/add';
    $.ajax({
        url: url,
        type: "post",
        async: false,
        data: {'cost_time_min': costTimeMin, 'plan_id': selectPlanId},
        dataType: "json",
        success: function(data) {
            var result = data.result;
            alert(result);
        },
        error: function() {
            alert('error');
        }

    });
}

function event_submitAdd() {
    var selectPlanId = $('#event_select').val();
    var name = $('#eventName').val();
    var url = mainUrl + 'index.php/api/event/add';
    $.ajax({
        url: url,
        type: "post",
        async: false,
        data: {'name': name, 'plan_id': selectPlanId},
        dataType: "json",
        success: function(data) {
            var result = data.result;
            alert(result);
        },
        error: function(data) {
            console.log(data);
            alert('error');
        }

    });
}

function submitEvaluation() {
    var selectPlanId = $('#selectPlanId2').val();
    var url = mainUrl + 'index.php/api/progress/evaluate?plan_id=' + selectPlanId;

    $.ajax({
        url: url,
        type: "get",
        async: false,
        dataType: "json",
        success: function(data) {

            var real_rate = data.complete_days / data.total_days;
            var plan_rate = data.plan.expect_rate;
            if (real_rate >= plan_rate)
            {
                var text = '<p><h2>Congratulations! Well done!</h2></p>' + data.html2;
            }
            else
            {
                var text = '<p><h2>Need to push myself!</h2></p>' + data.html2;
            }

            $('#evaluation_box').html(text);
        },
        error: function() {
            alert('error');
        }
    });
}

function loadTable(page)
{
    console.log(page);

    var url = mainUrl + 'index.php/api/progress/list?plan_id=1&count=10&page=' + page;
    $.ajax({
        url: url,
        type: "get",
        async: false,
        data: {},
        dataType: "json",
        success: function(data) {
            var objectArray = data.list;
            var displayArray = new Array();
            var pageCount = Math.round(data.sum / 10) + 1;

            for (i in objectArray)
            {
                item = objectArray[i];
                var myItem = new Object();
                myItem.cost_time_min = item.cost_time_min;
                myItem.created = item.created;
                displayArray.push(myItem);
            }

            var jsonHtmlTable = ConvertJsonToTable(
                    displayArray,
                    'jsonTable',
                    "table table-hover table-striped",
                    'Download'
                    );

            $('#progress_box').html(jsonHtmlTable);
        },
        error: function() {
            alert('error');
        }
    });
}

function evaluation_change()
{
    submitEvaluation();
}

function startPaging()
{
    var url = mainUrl + 'index.php/api/progress/list?plan_id=1&count=10&page=0';
    $.ajax({
        url: url,
        type: "get",
        async: false,
        data: {},
        dataType: "json",
        success: function(data) {
            loadTable(0);

            var objectArray = data.list;
            var displayArray = new Array();
            var pageCount = Math.round(data.sum / 10) + 1;

            $('.pagination').jqPagination({
                max_page: pageCount,
                paged: function(page) {
                    loadTable(page - 1);
                }
            });
        },
        error: function() {
            alert('error');
        }
    });
}