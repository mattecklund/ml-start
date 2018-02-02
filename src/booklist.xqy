xquery version "1.0-ml";

xdmp:set-response-content-type("text/html"),
('<!DOCTYPE html PUBLIC>',
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Book List</title>
  </head>
  <body>
      {
        for $book in fn:doc()
        return <p>{$book}</p>
      }
  </body>

</html>)