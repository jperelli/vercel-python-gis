# vercel-python-gis

A vercel python runtime that has GEOS, PROJ and GDAL installed so you can use the geospatial libraries of Django in vercel.

## Usage with django

with a directory structure like this
```
api/
  index.py
config/
  settings.py
  ...
core/
  models.py
  ...
vercel.json
```

in /vercel.json add this runtime
```json
{
  "routes": [
    {
      "src": "/(.*)",
      "dest": "api/index.py"
    }
  ],
  "functions": {
    "api/index.py": {
      "runtime": "vercel-python-gis@1.0.0",
      // "runtime": "git+https://github.com/jperelli/vercel-python-gis.git#main@1.0.0" // for dev only
    }
  }
}
```

In /config/settings.py add
```python
DATABASES = {
  'default': {
    'ENGINE': 'django.contrib.gis.db.backends.postgis',
    ...
  }
}

# IMPORTANT
GDAL_LIBRARY_PATH = "libgdal.so"
GEOS_LIBRARY_PATH = "libgeos_c.so.1"
```

Now in /core/models.py you can use gis models
```python
from django.contrib.gis.db import models
...
class MyModel(models.Model):
  ...
  geom = models.PolygonField()
  ...
```

And in /core/views.py you can use gis functions
```python
from django.contrib.gis.geos import Point
...
def my_view(request):
  p = Point(0, 0)
  ...
  return HttpResponse(p.wkt)
```

In /api/index.py
```python
import os
from django.core.wsgi import get_wsgi_application
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
app = get_wsgi_application()
```

# Develop vercel-python-gis.

## Build instructions

spin up the container with docker compose

```
docker-compose run --entrypoint='' builder bash
```

run the repo-build.sh inside the container

you should now have a /temp/stripped-files folder

copy /temp/stripped-files to /dist/files

## If you are changing code

Code is copied from @vercel/python runtime, that lives here https://github.com/vercel/vercel/tree/main/packages/python, it's almost the same code.
I'm trying to see if I can delete all that code from here and just use the @vercel/python, or inherit from it somehow.

If you are updating code in /src/*, you need to run `npm run build` before pushing the repo.

# License

MIT

with code from vercel https://github.com/vercel/vercel/blob/main/LICENSE
and distributing binary files from
 - libgdal https://gdal.org/license.html
 - libgeos https://github.com/libgeos/geos/blob/main/COPYING
 - libjbig https://github.com/ImageMagick/jbig/blob/main/COPYING
 - libjpeg https://github.com/libjpeg-turbo/libjpeg-turbo/blob/main/LICENSE.md
 - libproj https://github.com/OSGeo/PROJ/blob/master/COPYING
 - libsqlite https://www.sqlite.org/copyright.html
 - libtiff http://www.libtiff.org/misc.html
# Author

@jperelli
