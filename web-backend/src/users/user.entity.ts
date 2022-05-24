import { Column, Entity, PrimaryColumn, Unique } from 'typeorm';

@Entity()
export class User {
  @PrimaryColumn()
  userId: number;

  @Column({ unique: true })
  userName: string;
  @Column()
  password: string;
  @Column()
  name: string;
}
