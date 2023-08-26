from Crypto.Util.number import getPrime, bytes_to_long, long_to_bytes
import random
import secrets
from math import gcd
from hashlib import sha256

with open("flag.txt", "r") as f:
    flag = f.read().strip()

p=321745663660247264291912215381637140417426688166015765275016210974556618758108512916610772162708204242718465157404139876459846002727737598770450096642577891574129129971012786587775953761848931824322238298796689177818180751598982715142951891422895346040998252803256088344802677303563385039814682978344426511715095691285388244489299297982227614003912768214636964321398389670878817486572327863439909202202081589795055421943157234879795603541548858027867750020945742125759405585313
phip=321745663644137982453501751034221060149614281161498341317222863749664050347172052681857047928547879705531299049154183650170680637970523254049664158808042174556716753365060726738603147796721808427564722017179205844642415680516623360771297641357692292883806714929259580181939062408839661980293643073341981033892197854036112428722287761866221556690139833651293949000994649963638735512908155844345490505426385507145073171151591168489874072082195193477266931712000000000000000000000
q = 517705423061
g = 91384157732706561894240862291020814100232163578020188224013987566501068719193697433429376687956292689549685125437114305510875302249448048470055152232653696923116715050578314726096975526536966514396081128918628186978148074462022742249173353008488560690072216286423617034043589251733898683833101070262577048957426437334166578246979285804549486862642176493843475017343290237403960196329056137638907354788350228338636181542859137769034478800603005010521641255272986587838009655305
y = 133350043684365321588721685400003710817876062307631851818265309431175629011387252326584182507906412038760961954295641343399939878210771060821956263603208295030269994945240311979568764809004414973566661858254317787013992089878168141409961753554944616073264973119641924265805693654775720275441675395761126401828350310294339781822834967179003186339179915018046643981953674979871475811915487490518258933644557718975863645709635342798292628161575712337031555698137165663764479821759
x=337559397429

print(f"DEBUG DELETE: x={x}")
y = pow(g, x, p)

assert pow(g, q, p) == 1

def signing(message: bytes):
    r = 0; s = 0
    while r==0 or s==0:
        k = random.randint(1, q-1)
        r = pow(g, k, p) % q
        s = (pow(k, q-2, q) * (int(sha256(message).hexdigest(),16) + x*r)) % q
    return r, s

print(signing(b"bE0IgVoeM6U5Ofmh"))