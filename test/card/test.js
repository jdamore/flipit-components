'use strict';

import { expect } from 'chai';
import React from 'react';
import ReactDOM from 'react-dom';
import ReactTestUtils from 'react-addons-test-utils';
import _ from 'underscore';

import Card from '../../src/card/index';
import Styles from '../../src/card/index.scss';

Styles.container = 'container';
Styles.flipped = 'flipped';
Styles.front = 'front';
Styles.back = 'back';

describe('Card', () => {

	let component;
	let card, front, back;
	let props = { front:'word1', back: 12 }

	beforeEach(function() {
		component = ReactTestUtils.renderIntoDocument(<Card front={props.front} back={props.back}/>);
		card = ReactDOM.findDOMNode(component);
		let cardChildren = ReactTestUtils.scryRenderedDOMComponentsWithTag(component, 'div');
		front = _.find(cardChildren, n => n.getAttribute('name') === 'front');
		back = _.find(cardChildren, n => n.getAttribute('name') === 'back');
	});

	describe('render', () => {

  	it('renders the card', () => {
  			expect(card.getAttribute('name')).to.equal('card');
		});
	
  	it('renders the front', () => {
  			expect(front.getAttribute('name')).to.equal('front');
		});
	
  	it('renders the back', () => {
  			expect(back.getAttribute('name')).to.equal('back');
		});

	});

	describe('flip', () => {

		describe('first flip', () => {

			beforeEach(function() {
				component.flip();
			});
		
  		it('flips the card', () => {
  				expect(card.getAttribute('class')).to.contain('flipped');
			});
		
  		it('flips the word', () => {
  				expect(front.getAttribute('class')).to.contain('flipped');
			});
		
  		it('flips the score', () => {
  				expect(back.getAttribute('class')).to.contain('flipped');
			});

  		});

		describe('second flip', () => {

			let word;

			beforeEach(function() {
				word = front.innerHTML;
				component.flip();
				component.flip();
			});
		
  		it('unflips the card', () => {
  			expect(card.getAttribute('class')).not.to.contain('flipped');
			});
		
  		it('unflips the front', () => {
  			expect(front.getAttribute('class')).not.to.contain('flipped');
			});
		
  		it('unflips the back', () => {
  			expect(back.getAttribute('class')).not.to.contain('flipped');
			});
		
  		it('shows the same word', () => {
				let newWord = front.innerHTML;
  			expect(newWord).to.equal(word);
			});

  		});

	});

});