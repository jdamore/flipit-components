'use strict';

import React from 'react';
import styles from './index.scss';

export default class Card extends React.Component {

  constructor() {
    super();
    this.state = { flipped: false };
  }

  flip() {
    this.setState({ flipped: !this.state.flipped });
  }
 
  render() {
    return (
      <div name='card' className={ styles.container + ' ' + (this.state.flipped ? styles.flipped : '')} onClick={this.flip.bind(this)}>
        <div name='front' className={styles.front + ' ' + (this.state.flipped ? styles.flipped : '')}> {this.props.front} </div>
        <div name='back' className={styles.back + ' ' + (this.state.flipped ? styles.flipped : '')}> {this.props.back} </div>
      </div>
    );
  }
}

Card.propTypes = { front: React.PropTypes.string, back: React.PropTypes.number };
Card.defaultProps = { word: 'Flipit' };

