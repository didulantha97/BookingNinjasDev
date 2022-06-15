public class AlatAlat {
    public static String ubah(String raw_waktu) {
        String waktu = raw_waktu; // data waktu
        if (waktu.length() < 11) {
            waktu = '11 Jan 2000 - 12:35';
        }
        String[] list_tanggal = waktu.split(' '); // split tgl, bln, thn
        String tahun = list_tanggal[2];
        String bulan = getNumber(list_tanggal[1]);
        String tanggal = list_tanggal[0];
        return tahun + '-' + bulan + '-' + tanggal;
    }

    private static String getNumber(String bln) {
        String angka;
        if (bln.equals('Jan')) {
            angka = '1';
        } else if (bln.equals('Feb')) {
            angka = '2';
        } else if (bln.equals('Mar')) {
            angka = '3';
        } else if (bln.equals('Apr')) {
            angka = '4';
        } else if (bln.equals('May')) {
            angka = '5';
        } else if (bln.equals('Jun')) {
            angka = '6';
        } else if (bln.equals('Jul')) {
            angka = '7';
        } else if (bln.equals('Aug')) {
            angka = '8';
        } else if (bln.equals('Sep')) {
            angka = '9';
        } else if (bln.equals('Oct')) {
            angka = '10';
        } else if (bln.equals('Nov')) {
            angka = '11';
        } else if (bln.equals('Dec')) {
            angka = '12';
        } else {
            angka = '1';
        }

        return angka;
    }

    public static Id createGuest(Map<String, String> personData) {
        Id contactId = getContact(personData.get('email'));
        if (contactId == null) {
            Id accountId;
            if (personData.get('company') != null) {
                accountId = getAccount(personData.get('company'));
                if (accountId == null) {
                    Account company = new Account(Name = personData.get('company'));
                    insert company;
                    accountId = company.Id;
                }
            }

            Map<String, String> names = getFirstLastName(personData.get('name'));
            Contact guest = new Contact(
                FirstName = names.get('firstName'),
                LastName = names.get('lastName'),
                Email = personData.get('email')
            );
            if (personData.get('phone') != null) {
                guest.Phone = personData.get('phone');
            }
            if (accountId != null) {
                guest.AccountId = accountId;
            }
            insert guest;
            return guest.Id;
        }
        return contactId;
    }

    private static Id getAccount(String name) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = :name];
        if (accounts.size() > 0) {
            return accounts[0].Id;
        }
        return null;
    }

    private static Id getContact(String email) {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :email];
        if (contacts.size() > 0) {
            return contacts[0].Id;
        }
        return null;
    }

    public static Map<String, String> getFirstLastName(String fullName) {
        List<String> name;
        try {
            name = fullName.split(' ');
        } catch (Exception e) {
            name = new List<String>{ 'First Name', 'Last Name' };
        }
        String firstName = '';
        String lastName = '';
        if (name.size() == 1) {
            lastName = name[0];
        } else if (name.size() == 2) {
            firstName = name[0];
            lastName = name[1];
        } else {
            firstName = name[0];
            Integer idx = 0;
            for (String n : name) {
                if (idx != 0) {
                    lastName += name[idx] + ' ';
                }
                idx++;
            }
        }
        return new Map<String, String>{ 'firstName' => firstName, 'lastName' => lastName };
    }
}