import 'package:flutter/material.dart';

class TermsAndConditionsParagraph extends StatelessWidget {
  final String label, text;

  TermsAndConditionsParagraph({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  final Function hide;

  TermsAndConditions({required this.hide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ODRICANJE OD ODGOVORNOSTI',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => hide(),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                TermsAndConditionsParagraph(
                  label: 'Uslovi korišćenja',
                  text:
                      'Hvala Vam što ste posetili našu internet stranicu (u daljem tekstu: sajt). Pre korišćenja naših usluga, pažljivo pročitajte sledeće uslove. Svaka poseta našem internet sajtu, znači da ste ove uslove pročitali, razumeli i da se slažete sa njima u celosti. Ukoliko ne prihvatate ove uslove korišćenja bez ograničenja, molimo Vas da ne koristite naš sajt. Informacije koje se nalaze na ovim internet stranicama su prikupljene sa najvećom mogućom pažnjom. Vaš pristup, kao i korišćenje ovih stranica podleže ovim uslovima korišćenja i važećim zakonskim propisima koji uređuju ovu oblast. Posetom i korišćenjem ovih stranica sajta, smatra se da ste upoznati sa uslovima korišćenja i da bez ograničenja, prihvatate iste. Prihvatanjem ovih uslova smatra se da prihvatate korišćenje sadržaja ovih stranica isključivo za ličnu upotrebu i na sopstvenu odgovornost.',
                ),
                const SizedBox(height: 18),
                TermsAndConditionsParagraph(
                  label: 'Ograničenje pristupa',
                  text:
                      'Nepoštovanje uslova, rokova i napomena na ovim stranicama imaće za posledicu automatsko ukidanje svih prava koja su Vam dodeljena, bez prethodnog obaveštenja, a Vi morate odmah uništiti sve primerke materijala koje posedujete ili su pod Vašom kontrolom. Zadržavamo pravo, prema sopstvenoj odluci, da Vam zabrani pristup ovom sajtu ili nekom njegovom delu bez prethodnog upozorenja.',
                ),
                const SizedBox(height: 18),
                TermsAndConditionsParagraph(
                  label: 'Privatnost podataka',
                  text:
                      'Da bi ispunili Vaše zahteve i potrebe, prikupljamo samo neophodne, osnovne podatke o korisnicima i podatke neophodne za poslovanje i informisanje korisnika u skladu sa dobrim poslovnim običajima i u cilju pružanja kvalitetne usluge. Uz pomoć tih podataka bićemo u mogućnosti da Vam isporučimo željenu robu, kao i da Vas obavestimo o trenutnom statusu narudžbine. Obavezujemo se da će se čuvati privatnost svih korisnika sajta.Poštujemo privatnost svojih korisnika i u svemu poštuje odredbe Zakona o zaštiti podataka o ličnosti. Podatke koje korisnik ostavi na internet stranama i ostale podatke o korisniku,nećemo davati na uvid trećoj strani, sem u zakonu izričito predviđenim slučajevima.',
                ),
                const SizedBox(height: 18),
                TermsAndConditionsParagraph(
                  label: 'Opšte odricanje od odgovornosti',
                  text:
                      'Sajt koristite na sopstveni rizik i sopstvenu odgovornost. Bilo koje  povezano ili zavisno pravno lice, zaposleni ili rukovodilac, kao ni bilo koje treće lice angažovano od naše strane u kreiranju, proizvodnji i postavljanju i održavanju sajta, nisu odgovorni za materijalnu ili nematerijalnu, direktnu, indirektnu ili posledičnu štetu, kao i bilo koju drugu štetu koja nastane iz korišćenja ili je u nekoj vezi sa korišćenjem sajta ili njegovog sadržaja, bilo da je šteta zasnovana na ugovoru, da je vanugovorna i delikatna, čak i pored nečijeg obaveštenja da šteta može nastati i bez obzira da li je klijent bio obavešten o mogucnosti takve štete. Ukoliko iz bilo kog razloga, upotreba materijala, informacija ili usluga sa ovog sajta rezultira potrebom za servisiranjem opreme, Vi ste odgovorni za nastale troškove.\n'
                      'Ulažemo velike napore da bude bezbedno od virusa, ali ne možemo garantovati da virusa nikako nema. Iz tog razloga, preporučujemo da se postarate da na odgovarajući način obezbedite zaštitu od virusa (recimo, primenom skenera za virus) pre no što preuzmete dokumente i podatke.\n'
                      'Ne jemčimo da se neće dogoditi nikakva greška prilikom korišćenja usluga ponuđenih na internet sajtu, niti da će te usluge uvek biti na raspolaganju.',
                ),
                const SizedBox(height: 18),
                TermsAndConditionsParagraph(
                  label: 'Ograničenje odgovornosti',
                  text:
                      'Nastojimo da budemo što precizniji u opisu proizvoda, prikazu slika i samih cena. Međutim, ne može garantovati da su sve informacije kompletne i bez propusta, kako u pogledu štamparskih grešaka, opisa karakteristika, tako i cena. Zadržavamo pravo da promenimo sadržaj ovog sajta ili proizvode i cene navedene na sajtu u bilo koje vreme i bez prethodnog upozorenja. Takođe, može se desiti da sadržaj bude zastareo, međutim, ne obavezujemo se da se informacije redovno ažuriraju sadržane na ovom sajtu. Ne garantujemo da će ovaj sajt funkcionisati bez prekida i da će biti pravovremen, siguran ili bez grešaka. Takođe, ne garantujemo da će nedostaci biti blagovremeno pa čak ni periodično ispravljani ili da je sadržaj kompatibilan sa Vašim računarom, telefonom,hardverom ili softverom.\n'
                      'Informacije, saveti i mišljenja izraženi na ovom sajtu ne treba tumačiti kao savete za donošenje ličnih, finansijskih ili drugih odluka. Treba da se posavetujete sa odgovarajućim stručnjakom ako vam je potreban specifičan savet prilagođen Vašoj situaciji.\n'
                      'Izričito se odričemo, u najvećoj mogućoj zakonom dozvoljenoj meri, svih direktnih, posrednih, zakonskih i drugih garancija ili obaveza, uključujući i garancije isplativosti i svrsishodnosti, prikladnost za određene potrebe i garanciju u vezi sa svojinskim pravima ili pravima intelektualne svojine. Sajt sadrži informacije opšte prirode, koje nisu namenjene za rešavanje specifičnih situacija ili za neku konkretnu osobu ili entitet, i one ne prestavljaju profesionalni savet.',
                ),
                const SizedBox(height: 18),
                TermsAndConditionsParagraph(
                  label: 'Autorska prava - vlasništvo sadržaja',
                  text:
                      'Stranice na našem sajtu su zaštićene Zakonom o autorskim i srodnim pravima, Zakonom o žigovima i drugim srodnim zakonima. Svaka neovlašćena upotreba sadržaja, svako reprodukovanje, prilagođavanje, prevod, arhiviranje i obrada u drugim medijima, uključujući tu i arhiviranje ili obradu u elektronskim medijima, podležu zaštiti autorskih prava. Svako korišćenje, u celosti ili u delovima, nalaže da se prethodno dobije pismena dozvola kompanije Rescape. To znači da, ukoliko nije drugačije naznačeno, sav sadržaj (tekstualne, vizuelne i audio materijale, baze podataka, programerski kod) možete pregledati, kopirati, štampati ili preuzimati isključivo za ličnu, nekomercijalnu upotrebu i u informativne svrhe, pod uslovom da ne uklanjate, dodajete ili modifikujete bilo koju informaciju, uključujući i obaveštenja o autorskim pravima i ostala obaveštenja o vlasništvu, koja se nalaze u samom sadržaju.\n'
                      'Ne smete distribuirati, kopirati (osim pod uslovima navedenim u ovim uslovima korišćenja), prenositi, izlagati, objavljivati, štititi kao vaše pravo intelektualne svojine, kreirati izvedene radove, prodavati ili na bilo koji drugi način koristiti sadržaj bez prethodnog pismenog odobrenja Rescape Kao uslov za Vaš pristup i korišćenje ovog sajta, pod punom materijalnom i krivičnom odgovornošću izjavljujete da nećete koristiti ove stranice ni u kakve svrhe zabranjene ovim uslovima korišćenja, Zakonom ili na način koji se protivi javnom moralu. Zabranjeno je korišćenje naših internet stranica za postavljanje ili prenošenje bilo kakvog pretećeg, lažnog, obmanjujućeg, zloupotrebljavajućeg, maltretirajućeg, uznemiravajućeg, klevetničkog, vulgarnog, opscenog, skandaloznog, izazivačkog, pornografskog ili profanog materijala kojim se krše važeći zakonski propisi.\n'
                      'Izmenama teksta na ovoj stranici, možemo izmeniti Uslove u bilo kom trenutku. Vi ćete automatski biti obavezani novim uslovima korišćenja sadržanim u izmenama te bi trebalo da posetite ovu stranicu s vremena na vreme da biste se informisali o trenutno važećim uslovima zato što su oni za Vas zakonom obavezujući. Pojedine odredbe ovih Uslova mogu biti nadjačane zakonskim aktima ili navedenim pravnim obaveštenjima istaknutim na drugim stranicama našeg sajta. Nećemo biti odgovorni za moguće posledice proizašle iz eventualnih promena. Navedene promene stupaju na snagu objavljivanjem na ovim internet stranama.',
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
