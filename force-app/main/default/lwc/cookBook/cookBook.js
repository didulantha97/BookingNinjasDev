import { LightningElement, wire, track } from 'lwc';
import getAccountExecutives    from '@salesforce/apex/CookBookLWCController.getAccountExecutives';
import search                  from '@salesforce/apex/CookBookLWCController.search';
import { loadStyle }           from 'lightning/platformResourceLoader';
import brandStyles             from '@salesforce/resourceUrl/CreateInvoiceStyles';

const columns = [
    { label: 'Contact Name', fieldName: 'navigateToContactRecordPage', type: 'url', typeAttributes: { label: { fieldName: 'contactName'}, target: '_blank'}, sortable: true},
    { label: 'Account Name', fieldName: 'navigateToAccountRecordPage', type: 'url', typeAttributes: { label: { fieldName: 'accountName'}, target: '_blank'}, sortable: true},
    { label: 'CB Record Link', fieldName: 'navigateToCookBookRecordPage', type: 'url', typeAttributes: { label: { fieldName: 'navigateToCookBookRecordPage'}, target: '_blank'}, sortable: false},
    { label: 'Title', fieldName: 'contactTitle', type: 'text', sortable: true },
    { label: 'Scheduled Date', fieldName: 'scheduledDate', type: 'date', sortable: true },
    { label: 'Notes', fieldName: 'cookBookNotes', type: 'text', sortable: true },
    { label: 'Interest Level', fieldName: 'interestLevel', type: 'number', sortable: true },
    { label: 'Call Result', fieldName: 'callResult', type: 'text', sortable: true },
    { label: 'Linkedin', fieldName: 'contactLinkedIn', type: 'url', sortable: false },
    { label: 'Assigned To', fieldName: 'accountExecutiveNameAssignedTo', type: 'text', sortable: true }
];


export default class CookBook extends LightningElement {

    @track selectedAccount;
    @track selectedStartDate;
    @track selectedEndDate;
    @track selectedInterestLevel;
    @track selectedCallResult;
    @track selectedContinent;
    @track selectedHasPhone = false;
    @track selectedHasAccount = false;
    @track selectedLinkedInConnect = false;

    @track accountOptions;

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    sortBy(field, reverse, primer) {
        const key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return (a===null) - (b===null) || reverse * ((a > b) - (b > a));
        };
    }
 
    connectedCallback() {
        loadStyle(this, brandStyles);
    }

    handleSortData(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.cookBookList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.cookBookList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    @wire(getAccountExecutives) 
    accountsList({data,error}) {

        if(data){ 
            this.accountOptions = data.map(record => ({ label: record.Email__c, value: record.Id }));
            this.accountOptions.unshift( { label: '--Select--', value: '' } );
        } else {
            this.accountOptions = [{ label: '--Select--', value: '' }];
        }
    }

    get interestLevelOptions() {
        return [
            { label: '--Select--', value: '' },
            { label: '1', value: '1' },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
            { label: '6', value: '6' },
            { label: '7', value: '7' },
            { label: '8', value: '8' },
            { label: '9', value: '9' },
            { label: '10', value: '10' }
        ];

    }

    get callResultOptions() {
        return [
            { label: '--Select--', value: '' },
            { label: 'Appointments', value: 'Appointments' },
            { label: 'Call Backs', value: 'Call Backs' },
            { label: 'Contacted', value: 'Contacted' },
            { label: 'Voice Mail', value: 'Voice Mail' }
        ];

    }

    get continentOptions() {
        return [
            { label: '--Select--', value: '' },
            { label: 'Africa', value: 'Africa' },
            { label: 'Asia', value: 'Asia' },
            { label: 'Australia & Oceania', value: 'Australia & Oceania' },
            { label: 'EC America', value: 'EC America' },
            { label: 'EMEA', value: 'EMEA' },
            { label: 'Europe', value: 'Europe' },
            { label: 'South America', value: 'South America' },
            { label: 'WC America', value: 'WC America' }
        ];

    }


    handleSelected(event) {
        console.log(event.target.name);
        switch (event.target.name) {
            case 'selectAccount':
                this.selectedAccount = event.target.value;
                break;
            case 'selectStartDate':
                this.selectedStartDate = event.target.value;
                break;
            case 'selectEndDate':
                this.selectedEndDate = event.target.value;
                break;
            case 'selectInterestLevel':
                this.selectedInterestLevel = event.target.value;
                break;
            case 'selectCallResult':
                this.selectedCallResult = event.target.value;
                break;
            case 'selectContinent':
                this.selectedContinent = event.target.value;
                break;
            case 'selectHasPhone':
                (this.selectedHasPhone) ? this.selectedHasPhone = false : this.selectedHasPhone = true;
                break;
            case 'selectHasAccount':
                (this.selectedHasAccount) ? this.selectedHasAccount = false : this.selectedHasAccount = true;
                break;
            case 'selectLinkedInConnect':
                (this.selectedLinkedInConnect) ? this.selectedLinkedInConnect = false : this.selectedLinkedInConnect = true;
                break;
        }
    }


    @track cookBookList;
    @track countTotal;
    columns = columns;
    isLoading = false;

    handleSearchClicked(event) {
        this.isLoading = true;

        var searchParametres = {
            userId: this.selectedAccount,
            startDate: this.selectedStartDate,
            endDate: this.selectedEndDate,
            interestLevel: this.selectedInterestLevel,
            callResult: this.selectedCallResult,
            continent: this.selectedContinent,
            hasPhone: this.selectedHasPhone,
            hasAccount: this.selectedHasAccount,
            linkedinConnect: this.selectedLinkedInConnect
        };

        var json = JSON.stringify(searchParametres);
        console.log(json);
        console.log('in search:');
        search( {searchJson: json} )
            .then(result => {
                console.log('result' + JSON.parse(result));
                
                console.log('result' + result);
                
                let searchResult = JSON.parse(result);
                this.countTotal = searchResult.count;
                this.cookBookList = searchResult.searchResult;

                this.isLoading = false;
            })
            .catch(error => {
                console.log('error' + error);
                console.log('error' + JSON.stringify(error));
                this.isLoading = false;
            });
    }

}