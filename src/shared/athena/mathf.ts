namespace mathf {
    export function pointsOnSphere(fidelity: number) {
        let points: Vector3[] = []
        let goldenRatio = 1 + math.sqrt(5) / 4
        let angleIncrement = math.pi * 2 * goldenRatio
        let multiplier = 10

        for (let i = 0; i < fidelity; i++) {
            let distance = i / fidelity
            let incline = math.acos(1 - 2 * distance)
            let azimuth = angleIncrement * i

            let x = math.sin(incline) * math.cos(azimuth) * multiplier
            let y = math.sin(incline) * math.sin(azimuth) * multiplier
            let z = math.cos(incline) * multiplier

            points.push(new Vector3(x, y, z))

        }
        return points;
    }
    export function lerp(v0: number, v1: number, t: number) {
        return (1 - t) * v0 + t * v1;
    }
}

export = mathf;