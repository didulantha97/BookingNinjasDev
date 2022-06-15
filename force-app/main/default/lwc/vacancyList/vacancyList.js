import { LightningElement, wire, api, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getVacancies from "@salesforce/apex/BN_VacancyController.getVacancies";

export default class VacancyList extends NavigationMixin(LightningElement) {
  _vacancies;
  _errors;
  _detail_page_url = "/career/details";
  loading = true;
  @api vacancyId;
  @api thankyouPageUrl = "/thank-you-for-your-interest";
  @api mode;
  @api vacancyDetailViewUrl;

  connectedCallback() {
    this.loading = true;
  }

  @wire(getVacancies)
  retrievedVacancies({ data, error }) {
    if (data) {
      this._vacancies = data.map((d) => {
        return { detail_page_url: `${this._detail_page_url}?id=${d.Id}`, ...d };
      });
    }

    if (error) {
      this._errors = error;
    }
    this.loading = false;
  }

  get vacancies() {
    if (this._errors) {
      return [];
    }

    return this._vacancies || [];
  }

  get vacancySelected() {
    const p = this.vacancyId != null && this.vacancyId != undefined;

    return p;
  }

  get noVacancies() {
    return this.vacancies.length == 0;
  }

  // handleVacancyClick(event) {
  //   event.preventDefault();

  //   window.location.href = `${_detail_page_url}?id=${event.target.dataset.id}`;
  // }
}