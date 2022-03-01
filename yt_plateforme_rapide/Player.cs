using Godot;
using System;

public class Player : KinematicBody2D
{
    const int GRAVITY = 35;
    const int JUMP_FORCE = 550;
    const int SPEED = 300;
    const float ACCEL = 0.4f;

    AnimatedSprite sprite;
    Vector2 velocity = new Vector2();
    Vector2 scale = new Vector2(0, 1);

    public override void _Ready()
    {
        sprite = GetNode<AnimatedSprite>("AnimatedSprite");               
    }

    public override void _PhysicsProcess(float delta)
    {
        velocity.y += GRAVITY;

        var dir = Input.GetActionStrength("ui_right") - Input.GetActionStrength("ui_left");

        if (dir != 0) {
            scale.x = dir;
            sprite.Scale = scale;
        }

        if (IsOnFloor()) {
            if (dir != 0) {
                sprite.Play("Run");
            } else {
                sprite.Play("Idle");
            }
        }

        velocity.x = Mathf.Lerp(velocity.x, SPEED * dir, ACCEL);
        velocity = MoveAndSlide(velocity, Vector2.Up);
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("Jump") && IsOnFloor()) {
            velocity.y = -JUMP_FORCE;
            sprite.Play("Jump");
        }

        base._UnhandledInput(@event);
    }

}
