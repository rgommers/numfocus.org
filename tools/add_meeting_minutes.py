import datetime


def get_filename(date):
    return "{:%Y-%m-%d}.rst".format(date)


def top_four_lines(date):
    title = "Minutes - {:%B %d, %Y}\n".format(date)
    location = "foundation/minutes/board-meeting-minutes{:%Y-%m-%d}.html".format(date)
    url = ":url: " + location + '\n'
    saveas = ":save_as: " + location + '\n\n'

    header = title +'#' * len(title) + '\n' + url + saveas
    return header


template= """
Attendance
----------
**Participating**:

**Not Attending**:


Approval of Minutes from Last Meeting
-------------------------------------


Treasurer's Report
------------------


Items Approved by Email
=======================




Old Business
============




New Business
============

"""



# Edit this for the right date(s)!
dates_to_add = (
    (2014, 12, 15),
    )


for date in dates_to_add:
    date = datetime.datetime(*date)
    filename = get_filename(date)

    with open(filename, 'w') as f:
        f.write(top_four_lines(date) + template)

    # This goes into minutes/index.rst
    print("* `{:%Y-%m-%d} <|filename|{:%Y-%m-%d}.rst>`_".format(date, date))
