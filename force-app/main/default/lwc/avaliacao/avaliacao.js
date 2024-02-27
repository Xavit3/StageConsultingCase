import { LightningElement, track } from 'lwc';

const STAR_URL = '/resource/estrela';

export default class Avaliacao extends LightningElement {
    @track stars = [
        { id: 'star1', url: STAR_URL, rating: 1 },
        { id: 'star2', url: STAR_URL, rating: 2 },
        { id: 'star3', url: STAR_URL, rating: 3 },
        { id: 'star4', url: STAR_URL, rating: 4 },
        { id: 'star5', url: STAR_URL, rating: 5 }
    ];

    @track suggestion = '';

    handleSuggestionChange(event) {
        this.suggestion = event.target.value;
    }

    submitFeedback() {
        // Implemente a lógica para enviar o feedback e a sugestão
        console.log('Feedback enviado:', this.stars);
        console.log('Sugestão:', this.suggestion);

        // Ocultar o componente
        this.hideComponent();
    }

    hideComponent() {
        const hideEvent = new CustomEvent('hide');
        this.dispatchEvent(hideEvent);
    }
}