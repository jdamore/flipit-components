import React from 'react';

class Demo extends React.Component {
  render() {
    return (
      <div>
        <FlipitComponents.Card front={'test'} back={33} />
      </div>
    );
  }
}

export default Demo;
