import Matter from 'matter-js';

const WIDTH = 800;
const HEIGHT = 800;

export default class PhysicsCanvas {
  mounted() {
    const engine = Matter.Engine.create();
    engine.world.gravity = {
      x: 0,
      y: 0.1,
    };
    const render = Matter.Render.create({
      engine,
      element: this.el,
      options: {
        width: WIDTH,
        height: HEIGHT,
        wireframes: false,
      },
    });

    Matter.Render.run(render);
    const runner = Matter.Runner.create();
    Matter.Runner.run(runner, engine);

    const mouse = Matter.Mouse.create(render.canvas);
    const mouseConstraint = Matter.MouseConstraint.create(engine, { mouse });
    Matter.World.add(engine.world, mouseConstraint);
    Matter.Events.on(mouseConstraint, 'mousedown', (event) => {
      const body = Matter.Bodies.rectangle(
        event.mouse.position.x,
        event.mouse.position.y,
        50,
        50,
        { fillStyle: 'white' },
      );
      this.pushEvent('client-audio-update', {
        pos_x: body.position.x,
        pos_y: body.position.y,
      });
      Matter.World.add(engine.world, body);
    });
  }
}
