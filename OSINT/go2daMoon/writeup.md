1. reverse image search the given image, it is the thumbnail of this video -> https://www.youtube.com/watch?v=qkhL0u5Yy5Y
 
2. first four questions can be answered using the video

3. q5-8
<https://www.n2yo.com/database/?m=05&d=24&y=2019#results>
<https://space.skyrocket.de/doc_sdat/starlink-v0-9.htm>
<https://orbit.ing-now.com/satellite/44267/2019-029aj/starlink-69/>

4. for the next ones, you need to TLE data for norad id 44267(STARLINK-69) on the 26/05/19

> 1 44267U 19029AJ  19146.90842335  .00002305  00000+0  61114-4 0  9995
> 2 44267  53.0006 161.9964 0005743 275.6516 210.7143 15.42843617   511

you can get it from some source, the one i used is <https://celestrak.org/NORAD/archives/request.php>
here you can request specific data which is send via mail in an hour or so

you can then use something like tle.js <https://github.com/davidcalhoun/tle.js> or skyfield.py to extract data from the TLE.

skyfield soln:
```python
from skyfield.api import load, wgs84, EarthSatellite

ts = load.timescale()
line1 = '1 44267U 19029AJ  19147.55994082  .00004051  00000+0  10026-3 0  9999'
line2 = '2 44267  53.0006 158.9001 0005754 278.1127 229.0232 15.42845620  1493'

satellite = EarthSatellite(line1, line2, 'STARLINK-69', ts)
print(satellite)

t = ts.utc(2019, 5, 27, 16, 0, 0)

geocentric = satellite.at(t)
print(geocentric.position.km)

lat, lon = wgs84.latlon_of(geocentric)

print(f"{lat}, {lon}")
print(f"{lat.degrees}, {lon.degrees}")

print(wgs84.height_of(geocentric).km)
```

all answers:

```

1. What do you see? (starlink/satellite)
Ex. moon, orion, etc.

2. Where was this image capture? (netherlands)
Ex. India, USA, etc.

3. When was this image captured? (DD/MM/YYYY) (24/05/2019)
Ex. 

4. Who captured it? (Marco Langbroek)
Ex. Mike Wazozki

5. What vehicle was used for the launch of these satellites? (Falcon-9)
Ex. Saturn-V, Pegasus, etc.

6. What is the mass of each satellite in kg? (227)
Ex. 100

7. When did one of these satellites, STARLINK69 decay? (16/09/2020)

8. Where were they launched? (AIR FORCE RANGE/AIR FORCE TEST RANGE/AIR FORCE EASTERN TEST RANGE)
Ex. Goddard Test Site

The next questions will be in reference to STARLINK69, and date 27/05/19 16:00:00 UTC.
Please try to be as accurate as possible.

9. What was the height of the satellite in kms? (~438)

10. What was the velocity of the satellite? (~7.6)

11. What country was the satellite over? (yemen)
```