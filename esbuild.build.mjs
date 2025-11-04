import process from 'node:process';
import * as esbuild from 'esbuild';
import coffeeScriptPlugin from 'esbuild-coffeescript';

const esbuildOptions = {
  entryPoints: ['app/javascript/*.*'],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  plugins: [coffeeScriptPlugin()],
  define: {RAILS_ENV: `"${process.env.RAILS_ENV ?? "development"}"`}
}

if (process.argv.includes('--watch')) {
  const ctx = await esbuild.context(esbuildOptions);
  await ctx.watch();
  console.log('watching...');
} else {
  await esbuild.build(esbuildOptions);
}
