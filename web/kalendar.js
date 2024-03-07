// Define a list of months in Latin
mensis = ['Januarii', 'Februarii', 'Martii', 'Aprilis', 'Maii', 'Iunii', 'Iulii', 'Augusti', 'Septembris', 'Octobris', 'Novembris', 'Decembris']

// Define a function for generating the Divinum Officium Kalendar
function DivinumOfficiumKalendar(version, options)
{
    // Set the base URL for the XMLHttpRequest
    var url = 'http://divinumofficium.com/cgi-bin/horas/officium.pl?command=kalendar'

    // Set default values for options if they are not provided
    options = options || {}
    options.id = options.id || 'kalendar'
    options.link = options.link || 'http://divinumofficium.com'
    options.date = options.date || '%T %d.%B. a.D.%Y'

    // Get the current date and time
    var now = new Date()
    var now_date = "" + (now.getMonth()+1) + "-" + now.getDate() + "-" + now.getFullYear()
    var now_hour = now.getHours()

    // Determine the hour, suffix, and display date based on the current time
    var hour
    var suffix = 'Laudes'
    if ( 5 <= now_hour && now_hour < 18 )
    {
        hour = 'in die'
    }
    else if ( 18 <= now_hour && now_hour < 24 )
    {
        hour = 'ad vesperas'
        suffix = 'Vesperas'
    }
    else
    {
        hour = 'in nocte'
    }
    var display_date = options.date.replace('%T',hour).replace('%d',now.getDate()).replace('%B',mensis[now.getMonth()]).replace('%Y',now.getFullYear())

    // Write the link and display date to the page
    document.write('<a href="'+options.link+'" style="text-decoration:none;font-style:italic;text-align:center">')
    document.write(display_date + '<br>')
    document.write('<span id="' + options.id + '"></a>')

    // Create a new XMLHttpRequest object
    var kal = new XMLHttpRequest()

    // Set the innerHTML of the span element with the responseText of the
