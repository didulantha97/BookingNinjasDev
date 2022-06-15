@isTest
public class TestAlatAlat {
    @isTest static void testCreateGuest() {
        Map<String, String> personData = new Map<String, String>{
            'company' => 'Booking Ninjas',
            'name' => 'Teguh Prayoga',
            'email' => 'teguh@bookingninjas.com',
            'phone' => '+6291234030898'
        };
        Id hasil = AlatAlat.createGuest(personData);
        System.assertNotEquals(null, hasil);
    }

    @isTest static void testUbahString() {
        String waktu = '22 Mar 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-3-22', hasil);
    }
    
    @isTest static void testJan() {
        String waktu = '22 Jan 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-1-22', hasil);
    }
    
    @isTest static void testFeb() {
        String waktu = '22 Feb 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-2-22', hasil);
    }
    
    @isTest static void testMar() {
        String waktu = '22 Mar 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-3-22', hasil);
    }
    
    @isTest static void testApr() {
        String waktu = '22 Apr 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-4-22', hasil);
    }
    
    @isTest static void testMay() {
        String waktu = '22 May 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-5-22', hasil);
    }
    
    @isTest static void testJun() {
        String waktu = '22 Jun 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-6-22', hasil);
    }
    
    @isTest static void testJul() {
        String waktu = '22 Jul 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-7-22', hasil);
    }
    
    @isTest static void testAug() {
        String waktu = '22 Aug 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-8-22', hasil);
    }
    
    @isTest static void testSep() {
        String waktu = '22 Sep 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-9-22', hasil);
    }
    
    @isTest static void testOct() {
        String waktu = '22 Oct 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-10-22', hasil);
    }
    
    @isTest static void testNov() {
        String waktu = '22 Nov 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-11-22', hasil);
    }
    
    @isTest static void testDec() {
        String waktu = '22 Dec 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-12-22', hasil);
    }
    
    @isTest static void testErr() {
        String waktu = '22 Err 1993';
        String hasil = AlatAlat.ubah(waktu);
        System.assertEquals('1993-1-22', hasil);
    }
}